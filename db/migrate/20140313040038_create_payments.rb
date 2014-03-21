class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.float :price
      t.integer :user_id
      t.string :bitcoin_address
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
