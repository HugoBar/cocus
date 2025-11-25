module Recipes
  class AvailableRecipeSerializer

    def initialize(recipe)
      @recipe = recipe
    end

    def as_json
      {
        id: @recipe.id,
        name: @recipe.name,
        description: @recipe.description,
        prep_time: @recipe.prep_time,
        servings: @recipe.servings,
        steps: @recipe.steps,
        ingredients: serialize_ingredients(@recipe.ingredients),
        missing_ingredients: serialize_ingredients(@recipe.missing_ingredients),
        available: @recipe.available
      }
    end

    def self.serialize_collection(recipes)
      { collection: recipes.map { |recipe| new(recipe).as_json } }
    end

    private

    def serialize_ingredients(ingredients)
      ingredients.map do |ingredient|
        {
          name: ingredient.product.name,
          quantity: ingredient.quantity,
          unit: ingredient.unit
        }
      end
    end
  end
end
