module Products
  class ProductSerializer
    def initialize(product)
      @product = product
    end

    def as_json
      {
        id: @product.id,
        name: @product.name,
        unit: @product.unit
      }
    end

    def self.serialize_collection(products)
      {
        collection: [
          products.map do |product| 
            new(product).as_json
          end
        ]
      }
    end
  end
end