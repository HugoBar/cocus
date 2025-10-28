module Recipes
  class RecipeTrackerService
    def available_recipes
      ::Recipe
        .includes(recipe_products: :product)
        .all
        .select { |recipe| can_be_made?(recipe) }
    end

    private

    def can_be_made?(recipe)
      recipe.recipe_products.all? do |recipe_product|
        stored_product = ::Storage.find_by(product_id: recipe_product.product_id)
        next false unless stored_product

        required_quantity = UnitConverter.to_base(
          recipe_product.quantity,
          recipe_product.unit,
          stored_product.product
        )

        stored_product.quantity >= required_quantity
      end
    end
  end
end
