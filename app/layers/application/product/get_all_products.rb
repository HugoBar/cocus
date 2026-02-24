module Application
  module Product
    # Application use case responsible for retrieving all products.
    #
    # It coordinates domain repositories but does not contain
    # business rules itself.
    class GetAllProducts
      # Initializes the use case with required dependencies.
      #
      # @param product_repository [Domains::Product::ProductRepository]
      def initialize(product_repository:)
        @product_repository = product_repository
      end

      # Executes the use case.
      #
      # Loads all products and returns an array of DTO representations.
      #
      # @return [Array<Application::Product::Dto::ProductDto>]
      def call
        products = @product_repository.all

        products.map { |product| Dto::ProductDto.from_domain(product) }
      end
    end
  end
end