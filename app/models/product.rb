class Product < ApplicationRecord
  has_many :recipe_products
  has_many :recipes, through: :recipe_products
end
