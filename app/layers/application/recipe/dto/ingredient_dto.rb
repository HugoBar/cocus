module Application
  module Recipe
    module Dto
      # Data Transfer Object representing a recipe ingredient as exposed
      # by the application layer.
      #
      # This DTO is a lightweight, serialization‑friendly representation
      # of the domain Ingredient value object. Its sole purpose is to
      # transport data from the domain layer to the interface layer
      # (e.g., serializers, API responses).
      #
      # Example usage:
      #   ingredient_dto = IngredientDto.from_domain(ingredient)
      #
      #   ingredient_dto.product_id # => 42
      #   ingredient_dto.quantity   # => { amount: 100, unit: :g }
      class IngredientDto
        attr_reader :product_id, :quantity, :position

        # Initializes a new IngredientDto.
        #
        # @param product_id [Integer] the ID of the product used in the recipe
        # @param quantity [Hash] a flattened representation of the quantity
        #   (e.g., { amount: 100, unit: :g })
        # @param position [Integer] the ingredient's position/order in the recipe
        def initialize(product_id:, quantity:, position:)
          @product_id = product_id
          @quantity = quantity
          @position = position
        end

        # Builds an IngredientDto from a domain Ingredient value object.
        #
        # This method extracts only the data required for presentation and
        # flattens the Quantity value object into a simple Hash.
        #
        # @param ingredient [Domains::Recipe::Ingredient] the domain ingredient VO
        # @return [IngredientDto] a fully populated DTO
        #
        # Example:
        #   dto = IngredientDto.from_domain(ingredient)
        def self.from_domain(ingredient)
          new(
            product_id: ingredient.product_id,
            quantity: {
              amount: ingredient.quantity.amount,
              unit: ingredient.quantity.unit
            },
            position: ingredient.position
          )
        end
      end
    end
  end
end
