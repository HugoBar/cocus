module Recipes
  class RecipeTrackerSerializer
    def initialize(products)
      @products = products
    end

    def as_json
      {
        product_in_storage: serialize_products(@products)
      }
    end

    private

    def serialize_products(products)
      products.map do |product|
        {
          id: product.product_id,
          quantity: product.quantity,
          unit: product.unit
        }
      end
    end
  end
end