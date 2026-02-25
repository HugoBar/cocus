module Domains
  module Product
    require_relative "errors"

    MASS_UNITS = [ :kg, :g ].freeze
    BASE_UNITS = [ :count, :ml, :g ].freeze

    # Represents a product that can be used in recipes.
    #
    # A Product defines the base measurement unit used for the item,
    # and optionally a density when the unit is mass-based.
    #
    # Density is required when the product is measured in mass units,
    # as it allows conversion between mass and volume where needed.
    #
    # Example usage:
    #   product = Domains::Product::Product.new(
    #     id: 1,
    #     name: "Flour",
    #     unit: :g,
    #     density: 0.59
    #   )
    class Product
      attr_reader :id, :name, :unit, :density

      # Initializes a new Product object.
      #
      # @param id [Integer] unique identifier of the product
      # @param name [String] name of the product
      # @param unit [Symbol] base unit of measurement (:count, :ml, :g)
      # @param density [Numeric, nil] optional density (required for mass units)
      def initialize(id:, name:, unit:, density: nil)
        @id = id
        @name = name
        @unit = unit
        @density = density

        validate! # ensure the product is valid
      end

      private

      # Validates the product's attributes
      #
      # @raise [InvalidProductError] if any validation fails
      def validate!
        # Validate presence of name and unit
        raise InvalidProductError, "name cannot be blank" if name.nil? || name.strip.empty?
        raise InvalidProductError, "unit cannot be blank" if unit.nil?
        raise InvalidProductError, "unit must be valid" unless BASE_UNITS.include?(unit)

        # Ensure density is provided for mass units
        raise InvalidProductError, "density must be provided for mass units" if MASS_UNITS.include?(unit) && density.nil?

        # Validate density if provided
        if density
          raise InvalidProductError, "density must be a positive number" unless density > 0
        end
      end
    end
  end
end
