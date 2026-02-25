module Infrastructure
  module Persistence
    module Product
      module ArProductRepositoryHelper
        # Builds a domain product from an ActiveRecord product object
        def build_domain_product_from_ar(product)
          build_domain_product(
            id: product.id,
            name: product.name,
            unit: product.unit.to_sym,
            density: product.density
          )
        end

        # Builds a domain product entity from provided attributes.
        def build_domain_product(id:, name:, unit:, density:)
          Domains::Product::Product.new(
            id: id,
            name: name,
            unit: unit.to_sym,
            density: density
          )
        end
      end
    end
  end
end
