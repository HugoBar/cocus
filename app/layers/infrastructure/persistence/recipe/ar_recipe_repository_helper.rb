module Infrastructure
  module Persistence
    module Recipe
      # Helper module for ArRecipeRepository
      module ArRecipeRepositoryHelper
        # Builds a domain recipe from an ActiveRecord recipe object
        def build_domain_recipe_from_ar(recipe)
          build_domain_recipe(
            id: recipe.id,
            name: recipe.name,
            description: recipe.description,
            ingredients: ar_to_domain_ingredients(recipe.recipe_products),
            steps: ar_to_domain_steps(recipe.steps),
            servings: recipe.servings,
            prep_time: recipe.prep_time
          )
        end

        # Builds a domain recipe entity from provided attributes.
        def build_domain_recipe(id:, name:, description:, ingredients:, steps:, servings:, prep_time:)
          Domains::Recipe::Recipe.new(
            id: id,
            name: name,
            description: description,
            ingredients: ingredients,
            steps: steps,
            servings: servings,
            prep_time: prep_time
          )
        end

        # Converts ActiveRecord recipe_products to domain ingredient hashes.
        def ar_to_domain_ingredients(recipe_products)
          recipe_products.map do |i|
            { product_id: i.product_id, amount: i.quantity, unit: i.unit }
          end
        end

        # Converts ActiveRecord steps to domain step hashes.
        def ar_to_domain_steps(steps)
          steps.map.with_index { |s, idx| { position: s["position"], description: s["description"] } }
        end

        # Converts input ingredient attributes to domain ingredient hashes.
        def attributes_to_domain_ingredients(ingredients)
          ingredients.map { |i| { product_id: i[:product_id], amount: i[:amount], unit: i[:unit] } }
        end

        # Converts input step attributes to domain step hashes.
        def attributes_to_domain_steps(steps)
          steps.map { |s| { position: s[:position], description: s[:description] } }
        end

        # Validates that all ingredient product IDs exist and that units are compatible.
        # Accepts only domain ingredient objects.
        #
        # @param ingredients [Array<DomainIngredient>] The ingredients to validate.
        # @return [Hash{Integer => ::Product}] Indexed products hash.
        # @raise ActiveRecord::RecordNotFound if any product is missing.
        # @raise Domains::Recipe::InvalidQuantityError if any unit is incompatible.
        def validate_ingredients!(ingredients)
          product_ids = ingredients.map { |i| i.product_id }
          products = ::Product.where(id: product_ids).index_by(&:id)
          missing_product_ids = product_ids - products.keys
          if missing_product_ids.any?
            raise ActiveRecord::RecordNotFound, "Products with IDs #{missing_product_ids.join(', ')} not found"
          end

          errors = []
          ingredients.each do |ingredient|
            product = products[ingredient.product_id]
            quantity = ingredient.quantity
            begin
              quantity.assert_compatible_unit!(product.unit)
            rescue Domains::Recipe::InvalidQuantityError
              errors << "Invalid unit '#{quantity.unit}' for product '#{product.name}' (expected: '#{product.unit}')"
            end
          end
          unless errors.empty?
            raise Domains::Recipe::InvalidQuantityError, errors.join("; ")
          end
          products
        end
      end
    end
  end
end
