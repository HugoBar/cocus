class Recipe < ApplicationRecord
  has_many :recipe_products, dependent: :destroy
  has_many :products, through: :recipe_products

  validates :name, presence: true
  validates :steps, presence: true
  validate :must_have_at_least_one_recipe_product

  accepts_nested_attributes_for :recipe_products, allow_destroy: true

  attr_accessor :ingredients, :available, :missing_ingredients
  
  private

  def must_have_at_least_one_recipe_product
    if recipe_products.empty?
      errors.add(:recipe_products, "can't be blank")
    end
  end
end
