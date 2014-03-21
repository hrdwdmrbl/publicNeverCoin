class RegistrationsController < Devise::RegistrationsController
  def create
    params[:user][:password_confirmation] = params[:user][:password]
    User.transaction do
      @user = User.create(permitted_params[:user])
      stripe_customer = Stripe::Customer.create(email: permitted_params[:email])
      @user.stripe_customer_token = stripe_customer.id
      if @user.save
        sign_in :user, @user
        redirect_to new_payment_path
      else
        render 'new'
      end
    end
  end
protected
  def permitted_params
    params.permit(user: [:email, :password])
  end
end