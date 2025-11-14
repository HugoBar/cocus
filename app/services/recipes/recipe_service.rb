module Recipes
  class RecipeService
    def all
      Recipe.includes(recipe_products: :product).all
    end

    def find(id)
      Recipe.includes(recipe_products: :product).find(id)
    end

    def create(params)
      Recipe.create!(params)
    end

    def update(id, params)
      recipe = Recipe.includes(recipe_products: :product).find(id)
      recipe.update(params)
      recipe
    end

    def destroy(id)
      recipe = Recipe.find(id)
      recipe.destroy
    end
  end
end
