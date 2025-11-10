class Product < ApplicationRecord
  has_many :recipe_products
  has_many :recipes, through: :recipe_products

  validates :name, presence: true
  validates :unit, presence: true, inclusion: { in: %w[count g ml] }
end
