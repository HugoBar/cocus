module Infrastructure
  module Persistence
    module Recipe
      class ArRecipeRepository < Domains::Recipe::RecipeRepository
        def find(id)
          ar = ::Recipe.find(id)
          
          Domains::Recipe::Recipe.new(
            id: ar.id,
            name: ar.name,
            description: ar.description,
            ingredients: ar.ingredients.map { |i| { product_id: i.product_id, quantity: i.quantity } },
            steps: ar.steps.map { |s| { position: s.position, instruction: s.instruction } },
            servings: ar.servings,
            prep_time: ar.prep_time
          )
        end
      end
    end
  end
end
