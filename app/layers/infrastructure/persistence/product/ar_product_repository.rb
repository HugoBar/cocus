module Infrastructure
  module Persistence
    module Product
      # ActiveRecord-based implementation of the ProductRepository.
      #
      # This repository is responsible for retrieving product data from the
      # persistence layer (ActiveRecord models) and mapping it into
      # domain-level Product entities.
      class ArProductRepository < Domains::Product::ProductRepository

        # Finds a product by its ID.
        #
        # @param id [Integer] the product ID
        # @return [Domains::Product::Product] the domain product instance
        def find(id)
          product = ::Product.find(id)

          Domains::Product::Product.new(
            id: product.id,
            name: product.name,
            unit: product.unit.to_sym,
            density: product.density
          )
        end

        # Finds multiple products by their IDs.
        #
        # @param ids [Array<Integer>] list of product IDs
        # @return [Array<Domains::Product::Product>] domain product instances
        def find_by_ids(ids)
          products = ::Product.where(id: ids)

          products.map do |product|
            Domains::Product::Product.new(
              id: product.id,
              name: product.name,
              unit: product.unit.to_sym,
              density: product.density
            )
          end
        end
      end
    end
  end
end
