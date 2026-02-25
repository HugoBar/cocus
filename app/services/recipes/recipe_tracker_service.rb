module Recipes
  class RecipeTrackerService
    def available_recipes(include_unavailable: false)
      all_recipes = Recipe.includes(recipe_products: :product).all

      all_recipes = filtered_recipes(all_recipes) unless include_unavailable

      all_recipes.map do |recipe|
        available = can_be_made?(recipe)

        recipe.ingredients = recipe.recipe_products
        recipe.missing_ingredients = missing_ingredients_for(recipe, available)
        recipe.available = available

        recipe
      end
    end

    def complete_recipe(id, recipe)
      storage = Storages::StorageService.new.remove_batch(recipe[:recipe_products_attributes])

      log = RecipeLogs.create!(recipe_id: id, ingredients: recipe[:recipe_products_attributes])

      { storage: storage, recipe_id: log.recipe_id }
    rescue Unitwise::ConversionError => e
      raise ConversionError, e.message
    end

    private

    def filtered_recipes(recipes)
      recipes.select { |recipe| can_be_made?(recipe) }
    end

    def can_be_made?(recipe)
      recipe.recipe_products.all? do |recipe_product|
        product_in_storage = Storage.find_by(product_id: recipe_product.product_id)
        next false unless product_in_storage

        required_quantity = UnitConverter.to_base(
          recipe_product.quantity,
          recipe_product.unit,
          product_in_storage.product
        )

        product_in_storage.quantity >= required_quantity
      end
    end

    def missing_ingredients_for(recipe, available)
      return [] if available

      recipe.recipe_products.filter_map do |recipe_product|
        product_in_storage = Storage.find_by(product_id: recipe_product.product_id)
        next unless product_in_storage

        required_quantity = UnitConverter.to_base(
          recipe_product.quantity,
          recipe_product.unit,
          product_in_storage.product
        )

        missing_quantity = product_in_storage.quantity - required_quantity

        if missing_quantity.negative?
          IngredientItem.new(
            recipe_product.product,
            missing_quantity.abs,
            product_in_storage.unit
          )
        end
      end
    end
  end
end
