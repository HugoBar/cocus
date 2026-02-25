module Application
  module Product 
    # Service object for deleting a product.
    #
    # It coordinates domain repositories but does not contain
    # business rules itself.
    class DeleteProduct
      def initialize(product_repository:)
        @product_repository = product_repository
      end

      # Deletes a product by its ID.
      #
      # @param id [Integer] the ID of the product to delete
      # @return [Application::Product::Dto::ProductDto] the deleted product as a DTO
      def call(id:)
        product = @product_repository.delete(id)

        Dto::ProductDto.from_domain(product)
      end
    end
  end
end