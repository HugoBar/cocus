module Application
  module Product
    # Service object for creating a new product.
    #
    # This class encapsulates the logic for validating input attributes and
    # delegating the creation of a new product to the repository layer.
    #
    # @see Domains::Product::ProductRepository
    class CreateProduct
      def initialize(product_repository:)
        @product_repository = product_repository
      end

      # Executes the service to create a new product.
      #
      # @param attributes [Hash] the attributes for the new product (name, unit, density)
      # @return [Application::Product::Dto::ProductDto] the created product as a DTO
      # @raise ActiveRecord::RecordInvalid if validation fails in the repository layer.
      def call(attributes)
        product = @product_repository.create(attributes)

        Dto::ProductDto.from_domain(product)
      end
    end
  end
end