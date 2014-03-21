class Payment < ActiveRecord::Base
  belongs_to :user
  validates :bitcoin_address, presence: true, bitcoin_address: true
  validate :price, numericality: { less_than_or_equal_to: 0.07921921541289 }, presence: true
  validates :user, presence: true
end
