module Application
  module Product
    module Dto
      # Data Transfer Object representing a product as exposed by the
      # application layer.
      #
      # This DTO contains no business logic. It exists solely to carry
      # structured data from the domain layer to the interface layer
      # (e.g., serializers, controllers, API responses).
      #
      # Example usage:
      #   product_dto = ProductDto.from_domain(product)
      #
      #   product_dto.name    # => "Flour"
      #   product_dto.unit    # => :g
      #   product_dto.density # => 0.59
      class ProductDto
        attr_reader :id, :name, :unit, :density

        # Initializes a new ProductDto.
        #
        # @param id [Integer] the product's unique identifier
        # @param name [String] the product's name
        # @param unit [Symbol, String] the unit in which the product is measured
        # @param density [Float, nil] optional density value used for conversions
        def initialize(id:, name:, unit:, density:)
          @id = id
          @name = name
          @unit = unit
          @density = density
        end

        # Builds a ProductDto from a domain Product entity.
        #
        # This method extracts only the data required for presentation.
        #
        # @param product [Domains::Product::Product] the domain product entity
        # @return [ProductDto] a fully populated DTO
        #
        # Example:
        #   dto = ProductDto.from_domain(product)
        def self.from_domain(product)
          new(
            id: product.id,
            name: product.name,
            unit: product.unit,
            density: product.density
          )
        end
      end
    end
  end
end
