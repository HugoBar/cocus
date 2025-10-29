module Recipes
  class RecipeTrackerService
    def available_recipes
      ::Recipe
        .includes(recipe_products: :product)
        .all
        .select { |recipe| can_be_made?(recipe) }
    end

    def complete_recipe(recipe)
      #TODO: Create completed recipes log table
      Storages::StorageService.new.remove_batch(recipe[:ingredients])
    end

    private

    def can_be_made?(recipe)
      recipe.recipe_products.all? do |recipe_product|
        product_in_storage = ::Storage.find_by(product_id: recipe_product.product_id)
        next false unless product_in_storage

        required_quantity = UnitConverter.to_base(
          recipe_product.quantity,
          recipe_product.unit,
          product_in_storage.product
        )

        product_in_storage.quantity >= required_quantity
      end
    end
  end
end
