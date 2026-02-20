module Infrastructure
  module Persistence
    module Recipe
      # ActiveRecord-based implementation of the RecipeRepository.
      #
      # This repository is responsible for retrieving and persisting recipe data from the
      # persistence layer (ActiveRecord models) and mapping it into
      # domain-level Recipe entities.
      class ArRecipeRepository < Domains::Recipe::RecipeRepository

        # Finds a recipe by its ID.
        #
        # @param id [Integer] the unique identifier of the recipe
        # @return [Domains::Recipe::Recipe] the reconstructed domain recipe entity
        def find(id)
          recipe = ::Recipe.find(id)

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

          ar_recipe = nil
          ActiveRecord::Base.transaction do
            products = validate_ingredients!(domain_recipe.ingredients, :domain)

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

          # Rebuild and return the domain recipe object with the new id
          build_domain_recipe(
            id: ar_recipe.id,
            name: ar_recipe.name,
            description: ar_recipe.description,
            ingredients: ar_to_domain_ingredients(ar_recipe.recipe_products),
            steps: ar_to_domain_steps(ar_recipe.steps),
            servings: ar_recipe.servings,
            prep_time: ar_recipe.prep_time
          )
        end

        def update(id, attributes)
          recipe = ::Recipe.find(id)

          recipe.update(attributes)

          if attributes.key?(:ingredients)
            products = validate_ingredients!(attributes[:ingredients], :attributes)

            recipe.recipe_products.destroy_all
            attributes[:ingredients].each do |ingredient|
              recipe.recipe_products.create!(
                product_id: ingredient[:product_id],
                quantity: ingredient[:amount],
                unit: ingredient[:unit]
              )
            end
          end
          
          # Rebuild and return the updated domain recipe object
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
        
        # Shared ingredient validation for create and update
        # Accepts either domain ingredient objects or attribute hashes
        # Returns indexed products hash
        def validate_ingredients!(ingredients, type)
          product_ids =
            if type == :domain
              ingredients.map { |i| i.product_id }
            else
              ingredients.map { |i| i[:product_id] }
            end
          products = ::Product.where(id: product_ids).index_by(&:id)
          missing_product_ids = product_ids - products.keys
          if missing_product_ids.any?
            raise ActiveRecord::RecordNotFound, "Products with IDs #{missing_product_ids.join(', ')} not found"
          end

          errors = []
          ingredients.each do |ingredient|
            product =
              if type == :domain
                products[ingredient.product_id]
              else
                products[ingredient[:product_id]]
              end
            quantity =
              if type == :domain
                ingredient.quantity
              else
                Domains::Recipe::Quantity.new(amount: ingredient[:amount], unit: ingredient[:unit])
              end
            begin
              quantity.assert_compatible_unit!(product.unit)
            rescue Domains::Recipe::InvalidQuantityError
              errors << "Invalid unit '#{quantity.unit}' for product '#{product.name}' (expected: '#{product.unit}')"
            end
          end
          unless errors.empty?
            raise Domains::Recipe::InvalidQuantityError, errors.join('; ')
          end
          products
        end

        private

        # Builds a domain recipe entity from provided attributes.
        #
        # @param id [Integer, nil] the recipe id
        # @param name [String] the recipe name
        # @param description [String] the recipe description
        # @param ingredients [Array<Hash>] the ingredient attributes
        # @param steps [Array<Hash>] the step attributes
        # @param servings [Integer] the number of servings
        # @param prep_time [Float] the preparation time
        # @return [Domains::Recipe::Recipe] the domain recipe entity
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
        #
        # @param recipe_products [ActiveRecord::Relation] the recipe products
        # @return [Array<Hash>] the domain ingredient hashes
        def ar_to_domain_ingredients(recipe_products)
          recipe_products.map do |i|
            { product_id: i.product_id, amount: i.quantity, unit: i.unit }
          end
        end

        # Converts ActiveRecord steps to domain step hashes.
        #
        # @param steps [ActiveRecord::Relation] the recipe steps
        # @return [Array<Hash>] the domain step hashes
        def ar_to_domain_steps(steps)
          steps.map.with_index { |s, idx| { position: s["position"], description: s["description"] } }
        end

        # Converts input ingredient attributes to domain ingredient hashes.
        #
        # @param ingredients [Array<Hash>] the input ingredient attributes
        # @return [Array<Hash>] the domain ingredient hashes
        def attributes_to_domain_ingredients(ingredients)
          ingredients.map { |i| { product_id: i[:product_id], amount: i[:amount], unit: i[:unit] } }
        end

        # Converts input step attributes to domain step hashes.
        #
        # @param steps [Array<Hash>] the input step attributes
        # @return [Array<Hash>] the domain step hashes
        def attributes_to_domain_steps(steps)
          steps.map { |s| { position: s[:position], description: s[:description] } }
        end
      end
    end
  end
end
