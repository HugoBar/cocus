class Product < ApplicationRecord
  has_many :recipe_products
  has_many :recipes, through: :recipe_products

  validates :unit, presence: true, inclusion: { in: %w[pcs g ml] }
end
