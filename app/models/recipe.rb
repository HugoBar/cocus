class Recipe < ApplicationRecord
  has_many :recipe_products, dependent: :destroy
  has_many :products, through: :recipe_products

  validates :name, presence: true
  validates :steps, presence: true

  accepts_nested_attributes_for :recipe_products, allow_destroy: true

  attr_accessor :ingredients, :available, :missing_ingredients
  
end
