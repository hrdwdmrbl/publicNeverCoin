class AddExchangeRateToPayment < ActiveRecord::Migration
  def change
    add_column :payments, :exchange_rate, :float
  end
end
