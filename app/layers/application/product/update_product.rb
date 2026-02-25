module Application
  module Product
    # Service object for updating an existing product.
    #
    # This class encapsulates the logic for validating input attributes and
    # delegating the update of an existing product to the repository layer.
    #
    # @see Domains::Product::ProductRepository
    class UpdateProduct
      def initialize(product_repository:)
        @product_repository = product_repository
      end

      # Executes the service to update an existing product.
      #
      # @param id [Integer] the ID of the product to update
      # @param attributes [Hash] the attributes to update (name, unit, density)
      # @return [Application::Product::Dto::ProductDto] the updated product as a DTO
      def call(id:, attributes:)
        product = @product_repository.update(id, attributes)

        Dto::ProductDto.from_domain(product)
      end
    end
  end
end
