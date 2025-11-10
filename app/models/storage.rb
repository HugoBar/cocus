class Storage < ApplicationRecord
  belongs_to :product

  validates :product_id, presence: true
  validates :quantity, presence: true
  validates :unit, presence: true
end
