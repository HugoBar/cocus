module Infrastructure
  module Persistence
    module Recipe
      class ArRecipeRepository < Domains::Recipe::RecipeRepository
        def find(id)
          recipe = ::Recipe.find(id)

          Domains::Recipe::Recipe.new(
            id: recipe.id,
            name: recipe.name,
            description: recipe.description,
            ingredients: recipe.recipe_products.map { |i| { product_id: i.product_id, quantity: i.quantity, unit: i.unit } },
            steps: recipe.steps.map.with_index { |s, i| { position: i + 1, description: s } },
            servings: recipe.servings,
            prep_time: recipe.prep_time
          )
        end
      end
    end
  end
end
