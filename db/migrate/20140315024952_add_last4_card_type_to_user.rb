class AddLast4CardTypeToUser < ActiveRecord::Migration
  def change
    add_column :users, :last_4, :string
    add_column :users, :card_type, :string
  end
end
