module Infrastructure
  module Persistence
    module Recipe
      # ActiveRecord-based implementation of the RecipeRepository.
      #
      # This repository handles all persistence operations for recipes using ActiveRecord models.
      # It is responsible for retrieving, creating, and updating recipe data in the database.
      #
      #
      # @see Domains::Recipe::RecipeRepository
      class ArRecipeRepository < Domains::Recipe::RecipeRepository
        include Infrastructure::Persistence::Recipe::ArRecipeRepositoryHelper

        # Finds a recipe by its ID.
        #
        # @param id [Integer] the unique identifier of the recipe
        # @return [Domains::Recipe::Recipe] the reconstructed domain recipe entity
        def find(id)
          recipe = ::Recipe.find(id)
          build_domain_recipe_from_ar(recipe)
        end

        # Creates a new recipe and its associated ingredients and steps.
        #
        # @param attributes [Hash] The attributes for the new recipe, including:
        #   - :name [String]
        #   - :description [String]
        #   - :ingredients [Array<Hash>] (each with :product_id, :amount, :unit)
        #   - :steps [Array<Hash>] (each with :position, :description)
        #   - :servings [Integer]
        #   - :prep_time [Float]
        # @return [Domains::Recipe::Recipe] The created domain recipe entity.
        # @raise ActiveRecord::RecordInvalid if validation fails.
        # @raise ActiveRecord::RecordNotFound if any product is missing.
        def create(attributes)
          # Build a domain recipe object for validation (no id yet)
          domain_recipe = build_domain_recipe(
            id: nil,
            name: attributes[:name],
            description: attributes[:description],
            ingredients: attributes_to_domain_ingredients(attributes[:ingredients]),
            steps: attributes_to_domain_steps(attributes[:steps]),
            servings: attributes[:servings],
            prep_time: attributes[:prep_time]
          )

          ActiveRecord::Base.transaction do
            products = validate_ingredients!(domain_recipe.ingredients)

            ar_recipe = ::Recipe.create!(
              name: domain_recipe.name,
              description: domain_recipe.description,
              servings: domain_recipe.servings,
              prep_time: domain_recipe.prep_time,
              steps: domain_recipe.steps
            )

            # Create associated recipe_products for each ingredient
            domain_recipe.ingredients.each do |ingredient|
              ar_recipe.recipe_products.create!(
                product_id: ingredient.product_id,
                quantity: ingredient.quantity.amount,
                unit: ingredient.quantity.unit
              )
            end
          end

          build_domain_recipe_from_ar(ar_recipe)
        end

        # Updates an existing recipe and its associated ingredients.
        #
        # @param id [Integer] The ID of the recipe to update.
        # @param attributes [Hash] The attributes to update (same structure as #create).
        # @return [Domains::Recipe::Recipe] The updated domain recipe entity.
        # @raise ActiveRecord::RecordNotFound if the recipe or any product is missing.
        # @raise ActiveRecord::RecordInvalid if validation fails.
        def update(id, attributes)
          recipe = ::Recipe.find(id)
          
          ActiveRecord::Base.transaction do
            recipe.update(attributes)

            if attributes.key?(:ingredients)
              domain_ingredients = attributes_to_domain_ingredients(attributes[:ingredients])
              products = validate_ingredients!(domain_ingredients)

              recipe.recipe_products.destroy_all
              attributes[:ingredients].each do |ingredient|
                recipe.recipe_products.create!(
                  product_id: ingredient[:product_id],
                  quantity: ingredient[:amount],
                  unit: ingredient[:unit]
                )
              end
            end
          end
          build_domain_recipe_from_ar(recipe)
        end
        
        # Deletes a recipe by its ID.
        #
        # @param id [Integer] The ID of the recipe to delete.
        # @return [Domains::Recipe::Recipe] The deleted domain recipe entity.
        # @raise ActiveRecord::RecordNotFound if the recipe does not exist.
        def delete(id)
          recipe = ::Recipe.find(id)
          domain_recipe = build_domain_recipe_from_ar(recipe)
          recipe.destroy
          domain_recipe
        end

        private
      end
    end
  end
end
