module Infrastructure
  module Persistence
    module Product
      # ActiveRecord-based implementation of the ProductRepository.
      #
      # This repository is responsible for retrieving product data from the
      # persistence layer (ActiveRecord models) and mapping it into
      # domain-level Product entities.
      class ArProductRepository < Domains::Product::ProductRepository
        include Infrastructure::Persistence::Product::ArProductRepositoryHelper

        # Retrieves all products.
        #
        # @return [Array<Domains::Product::Product>] an array of domain product instances
        def all
          ::Product.all.map do |product|
            build_domain_product_from_ar(product)
          end
        end
        
        # Finds a product by its ID.
        #
        # @param id [Integer] the product ID
        # @return [Domains::Product::Product] the domain product instance
        def find(id)
          product = ::Product.find(id)

          build_domain_product_from_ar(product)
        end

        # Finds multiple products by their IDs.
        #
        # @param ids [Array<Integer>] list of product IDs
        # @return [Array<Domains::Product::Product>] domain product instances
        def find_by_ids(ids)
          products = ::Product.where(id: ids)

          products.map do |product|
            build_domain_product_from_ar(product)
          end
        end

        # Creates a new product.
        #
        # @param attributes [Hash] the attributes for the new product (name, unit, density)
        # @return [Domains::Product::Product] the created domain product instance
        def create(attributes)
          domain_product = build_domain_product(
            id: nil,
            name: attributes[:name],
            unit: attributes[:unit],
            density: attributes[:density]
          )

          ar_product = ::Product.create!(
            name: domain_product.name,
            unit: domain_product.unit.to_s,
            density: domain_product.density
          )

          build_domain_product_from_ar(ar_product)
        end
      end
    end
  end
end
