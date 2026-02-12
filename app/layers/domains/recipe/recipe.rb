module Domains
  module Recipe
    require_relative 'errors'

    # Represents a cooking recipe with its name, description, ingredients, steps,
    # number of servings, and preparation time.
    #
    # Example usage:
    #   recipe = Domains::Recipe::Recipe.new(
    #     "Pancakes",
    #     "Fluffy homemade pancakes",
    #     [{ product_id: 1, quantity: "2 cups" }, { product_id: 2, quantity: "1 cup" }],
    #     [{ position: 1, instruction: "Mix ingredients" }, { position: 2, instruction: "Cook on skillet" }],
    #     4,
    #     15.0
    #   )
    class Recipe 
      attr_reader :id, :name, :description, :ingredients, :steps, :servings, :prep_time

      # Initializes a new Recipe object.
      #
      # @param name [String] the recipe's name
      # @param description [String] a description of the recipe
      # @param ingredients [Array<Hash>] list of ingredient attributes
      # @param steps [Array<Hash>] list of step attributes
      # @param servings [Integer] number of servings
      # @param prep_time [Float] preparation time in minutes
      def initialize(id:, name:, description:, ingredients:, steps:, servings:, prep_time:)
        @id = id
        @name = name
        @description = description
        @ingredients = ingredients.map { |i| Ingredient.new(**i) } 
        @steps = steps.map { |s| Step.new(**s) }
        @servings = servings.to_i
        @prep_time = prep_time.to_f

        validate! # ensure the recipe is valid
      end 

      private 

      # Validates the recipe's attributes
      #
      # @raise [InvalidRecipeError] if any validation fails
      def validate!
        # Validate presence of name and description
        raise InvalidRecipeError, "name cannot be blank" if name.nil? || name.strip.empty?
        raise InvalidRecipeError, "description cannot be blank" if description.nil? || description.strip.empty?

        # Add validation to ensure there is at least one ingredient and one step
        raise InvalidRecipeError, "at least one ingredient is required" if ingredients.empty?
        raise InvalidRecipeError, "at least one step is required" if steps.empty?

        # Ensure no duplicate ingredients
        product_ids = ingredients.map(&:product_id)
        duplicates = product_ids.select { |id| product_ids.count(id) > 1 }.uniq
        if duplicates.any?
          raise InvalidRecipeError, "duplicate ingredients found (product IDs: #{duplicates.join(', ')})"
        end

        # Ensure steps positions are unique
        steps_position = steps.map(&:position)
        duplicates = steps_position.select { |n| steps_position.count(n) > 1 }.uniq
        if duplicates.any?
          raise InvalidRecipeError, "multiple steps in the same position found (position: #{duplicates.join(', ')})"
        end

        # Validate servings
        raise InvalidRecipeError, "servings must be more than 0" unless servings > 0
        raise InvalidRecipeError, "servings cannot exceed 999" if servings > 999

        # Validate preparation time
        raise InvalidRecipeError, "prep_time must be more than 0" unless prep_time > 0
        raise InvalidRecipeError, "prep_time cannot exceed 999" if prep_time > 999
      end
    end
  end
end
