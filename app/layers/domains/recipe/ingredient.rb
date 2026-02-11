module Domains
  module Recipe
    require_relative 'errors'

    # Represents a single ingredient in a recipe.
    #
    # Ingredient is a Value Object (VO), meaning it is immutable and represents
    # an atomic piece of data in a recipe.
    #
    # Each ingredient has a product_id, quantity (wrapped in a Quantity object),
    # and an optional position indicating its order in the ingredient list.
    #
    # Example usage:
    #   ingredient = Domains::Recipe::Ingredient.new(
    #     product_id: 1,
    #     quantity: 2,
    #     unit: "cups",
    #     position: 1
    #   )
    class Ingredient
      include Domains::Shared::ValueObject

      # Attributes used to determine equality for the Value Object
      equality_attributes :product_id, :quantity

      attr_reader :product_id, :quantity, :position

      # Initializes a new Ingredient object.
      #
      # @param product_id [Integer] the ID of the product
      # @param quantity [Numeric] the numeric amount of the ingredient
      # @param unit [String] the unit of measurement for the quantity
      # @param position [Integer, nil] optional position in the ingredient list
      def initialize(product_id:, quantity:, unit:, position: nil)
        @product_id = product_id.to_i
        @quantity = Quantity.new(amount: quantity, unit:)
        @position = position.to_i if position
        
        validate! # ensure the ingredient is valid
        freeze    # immutability for VO
      end

      private

      # Validates the ingredient's attributes
      #
      # @raise [InvalidIngredientError] if any validation fails
      def validate!
        # Validate product_id presence and positivity
        raise InvalidIngredientError, "product_id is required" if product_id <= 0        
        # Validate position positivity if present
        raise InvalidIngredientError, "position must be positive if present" if !position.nil? && position.to_i <= 0
      end
    end
  end
end
