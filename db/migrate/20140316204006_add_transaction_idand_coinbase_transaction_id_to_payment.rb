class AddTransactionIdandCoinbaseTransactionIdToPayment < ActiveRecord::Migration
  def change
    add_column :payments, :transaction_id, :string
    add_column :payments, :coinbase_transaction_id, :string
  end
end
