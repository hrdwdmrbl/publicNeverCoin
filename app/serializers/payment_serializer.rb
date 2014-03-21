class PaymentSerializer < ActiveModel::Serializer
  attributes :id, :price, :user_id, :bitcoin_address, :title, :description
end
