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
      def call(id)
        @product_repository.delete(id)
      end
    end
  end
end