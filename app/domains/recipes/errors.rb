module Domain
  module Recipe
    class InvalidRecipeError < StandardError; end
    class InvalidIngredientError < StandardError; end
    class InvalidQuantityError < StandardError; end
    class InvalidStepError < StandardError; end
  end
end
