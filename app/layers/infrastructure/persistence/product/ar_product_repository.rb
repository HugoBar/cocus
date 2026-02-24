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

        # Updates an existing product.
        #
        # @param id [Integer] the product ID
        # @param attributes [Hash] the attributes to update (name, unit, density)
        # @return [Domains::Product::Product] the updated domain product instance        
        def update(id, attributes)
          if attributes.key?(:unit)
            raise Domains::Product::InvalidProductError, "Unit cannot be updated for a product."
          end

          ar_product = ::Product.find(id)

          # Build a domain product to validate new state and apply business rules
          domain_product = build_domain_product(
            id: ar_product.id,
            name: attributes[:name] || ar_product.name,
            unit: ar_product.unit, # unit is immutable
            density: attributes[:density] || ar_product.density
          )

          # Update the ActiveRecord product with validated values
          ar_product.update!(
            name: domain_product.name,
            density: domain_product.density
          )

          build_domain_product_from_ar(ar_product)
        end
      end
    end
  end
end
