module Domains
  module Recipe
    require_relative 'errors'
    require 'bigdecimal'

    MAPPED_MEASURE_UNITS = {
      ml: :ml,
      l: :ml,
      tablespoon: :ml,
      teaspoon: :ml,
      cup: :ml,
      count: :ml,
      g: :g,
      kg: :g
    }
    
    # Represents a quantity for an ingredient, combining an amount and a unit.
    #
    # Quantity is a Value Object (VO), meaning it is immutable and represents
    # an atomic piece of data in a recipe.
    #
    # Each quantity has an amount (as BigDecimal) and a unit (as a symbol). 
    # It is used in the Ingredient VO.
    #
    # Example usage:
    #   quantity = Domains::Recipe::Quantity.new(
    #     amount: 2,
    #     unit: "cups"
    #   )
    class Quantity
      include Domains::Shared::ValueObject

      # Attributes used to determine equality for the Value Object
      equality_attributes :amount, :unit

      attr_reader :amount, :unit

      # Initializes a new Quantity object.
      #
      # @param amount [Numeric] the numeric amount of the ingredient
      # @param unit [String, Symbol] the unit of measurement
      def initialize(amount:, unit:)
        @amount = to_big_decimal(amount) # ensure numeric precision
        @unit = unit.to_sym

        validate! # ensure the quantity is valid
        freeze    # immutability for VO
      end

      # Checks if the quantity's unit is compatible with the given unit.
      #
      # Raises an InvalidQuantityError if the units are not compatible.
      #
      # @param unit [String, Symbol] the unit to check compatibility against
      # @raise [InvalidQuantityError] if the units are not compatible
      def assert_compatible_unit!(unit)
        unless MAPPED_MEASURE_UNITS[@unit.to_sym] == unit.to_sym
          raise InvalidQuantityError, "Invalid unit '#{@unit}'"
        end
      end

      private

      # Converts a value to BigDecimal
      #
      # @param value [Numeric, String] the value to convert
      def to_big_decimal(value)
        begin
          BigDecimal(value.to_s)
        rescue ArgumentError
          raise InvalidQuantityError, "amount must be a valid number '#{value}'"
        end
      end

      # Validates the quantity's attributes
      #
      # @raise [InvalidQuantityError] if any validation fails
      def validate!
        # Validate amount
        raise InvalidQuantityError, "amount must be more than 0" unless amount > 0
        raise InvalidQuantityError, "amount cannot exceed 999" if amount > 999

        # Validate unit
        raise InvalidQuantityError, "unit must be valid" unless ALLOWED_UNITS.include?(unit.to_s)
      end
    end
  end
end
