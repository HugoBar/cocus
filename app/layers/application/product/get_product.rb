module Application
  module Product
    # Application use case responsible for retrieving a single product.
    #
    # It coordinates domain repositories but does not contain
    # business rules itself.
    class GetProduct
      # Initializes the use case with required dependencies.
      #
      # @param product_repository [Domains::Product::ProductRepository]
      def initialize(product_repository:)
        @product_repository = product_repository
      end

      # Executes the use case.
      #
      # Fetches the product by ID.
      #
      # @param id [Integer] the unique identifier of the product to retrieve
      # @return [Application::Product::Dto::ProductDto]
      def call(id:)
        product = @product_repository.find(id)

        Product::Dto::ProductDto.from_domain(product)
      end
    end
  end
end