module Infrastructure
  module Persistence
    module Recipe
      # ActiveRecord-based implementation of the RecipeRepository.
      #
      # This repository is responsible for retrieving recipe data from the
      # persistence layer (ActiveRecord models) and mapping it into
      # domain-level Recipe entities.
      class ArRecipeRepository < Domains::Recipe::RecipeRepository

        # Finds a recipe by its ID.
        #
        # @param id [Integer] the unique identifier of the recipe
        # @return [Domains::Recipe::Recipe] the reconstructed domain recipe entity
        def find(id)
          recipe = ::Recipe.find(id)

          Domains::Recipe::Recipe.new(
            id: recipe.id,
            name: recipe.name,
            description: recipe.description,
            ingredients: recipe.recipe_products.map { |i| { product_id: i.product_id, amount: i.quantity, unit: i.unit } },
            steps: recipe.steps.map.with_index { |s, idx| { position: idx + 1, description: s } },
            servings: recipe.servings,
            prep_time: recipe.prep_time
          )
        end
      end
    end
  end
end
