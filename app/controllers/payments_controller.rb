class PaymentsController < InheritedResources::Base
  actions :create, :index, :edit, :update, :new
  respond_to :html
  def new
    response = Typhoeus.get("https://coinbase.com/api/v1/currencies/exchange_rates")
    @rates = JSON.parse(response.body)
    gon.rates = @rates
    new!
  end
  def create
    response = Typhoeus.get("https://coinbase.com/api/v1/currencies/exchange_rates")
    rates = JSON.parse(response.body)
    exchange_rate = rates['usd_to_btc'].to_f

    @payment = Payment.new(new_permitted_params[:payment])
    @payment.exchange_rate = exchange_rate
    @payment.user = current_user
    authorize! :create, @payment

    customer = Stripe::Customer.retrieve(current_user.stripe_customer_token)
    card = if customer.cards and customer.cards.count > 0
      customer.cards.first
    else
      [
        {data: :cc_number, friendly: 'Credit Card Number'},
        {data: :cc_exp_month, friendly: 'Credit Card Expiration Month'},
        {data: :cc_exp_year, friendly: 'Credit Card Expiration Year'},
        {data: :cc_cvc, friendly: 'Credit Card Expiration CVC'},
        {data: :cc_name, friendly: 'Credit Card Expiration Name'}
      ].each do |feild|
        if params[feild[:data]].empty?
          @payment.errors[feild[:data]] << " is missing"
        end
      end
      if @payment.errors.empty?
        begin
          card = customer.cards.create(card: cc_from_skeuocard)
          current_user.last_4 = card.last4
          current_user.card_type = card.type
          current_user.save
        rescue Stripe::CardError => e
          @payment.errors[:credit_card] = e.message
        end
      end
    end

    if @payment.errors.empty?
      Retriable.retriable do
        begin
          amount = (@payment.price/exchange_rate)
          amount_with_fee = amount*1.06
          amount_with_fee_in_cents = (amount_with_fee.round(2)*100).to_i
          Stripe::Charge.create(
            amount: amount_with_fee_in_cents,
            currency: "usd",
            customer: customer,
            description: @payment.title
          )
        rescue StripeError => e
          @payment.errors[:credit_card] = e.message
        end
      end

      if @payment.errors.empty? and @payment.save

        coinbase_transaction_id = nil

        coinbase_transaction = Retriable.retriable do
          options = @payment.price < 0.01 ? {transaction: {user_fee: '0.0002'}} : {}
          $coinbase.send_money(@payment.bitcoin_address, @payment.price, "payment_id: #{@payment.id}", options)
        end

        @payment.coinbase_transaction_id = coinbase_transaction["transaction"]['id']

        if @payment.save
          flash[:notice] = "You successfully bought #{@payment.title}"
          redirect_to payments_path
        else
          gon.rates = rates
          @rates = rates
          render 'new'
        end
      else
        gon.rates = rates
        @rates = rates
        render 'new'
      end
    else
      gon.rates = rates
      @rates = rates
      render 'new'
    end
  end
  def index
    if current_user
      @payments = Payment.where(user_id: current_user.id)
      @payments.select!{|payment| can? :read, payment }
      index!
    else
      redirect_to root_path
    end
  end
  def update
    @payment = Payment.find(params[:id])
    @payment.update_attributes(update_permitted_params[:payment])
    if @payment.errors.empty?
      redirect_to payments_path
    else
      render 'edit'
    end
  end
protected
  def new_permitted_params
    params.permit(
      {payment: [:title, :description, :price, :bitcoin_address]},
      :cc_type, :cc_number, :cc_exp_month, :cc_exp_year, :cc_name, :cc_cvc
    )
  end
  def update_permitted_params
    params.permit(payment: [:title, :description])
  end

  def cc_from_skeuocard
    {
      number: new_permitted_params[:cc_number],
      exp_month: new_permitted_params[:cc_exp_month],
      exp_year: new_permitted_params[:cc_exp_year],
      cvc: new_permitted_params[:cc_cvc],
      name: new_permitted_params[:cc_name]
    }
  end
end
