module Recipes
  class AvailableRecipeSerializer
    attr_reader :recipe, :available, :missing_ingredients

    def initialize(recipe)
      @recipe = recipe[:recipe]
      @available = recipe[:available]
      @missing_ingredients = recipe[:missing_ingredients]
    end

    def as_json
      {
        recipe: serialize_recipe,
        available: available,
        missing_ingredients: serialize_ingredients(missing_ingredients)
      }
    end

    def self.serialize_collection(recipes)
      { collection: recipes.map { |recipe| new(recipe).as_json } }
    end

    private

    def serialize_recipe
      {
        id: recipe.id,
        name: recipe.name,
        description: recipe.description,
        prep_time: recipe.prep_time,
        servings: recipe.servings,
        steps: recipe.steps,
        ingredients: serialize_ingredients(recipe.recipe_products)
      }
    end

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
