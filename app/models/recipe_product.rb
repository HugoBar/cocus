class RecipeProduct < ApplicationRecord
  belongs_to :recipe
  belongs_to :product
end
