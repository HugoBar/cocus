module Recipes
  class CompleteRecipeSerializer
    attr_reader :products, :recipe_id

    def initialize(completion)
      @products = completion[:storage]
      @recipe_id = completion[:recipe_id]
    end

    def as_json
      {
        completed: true,
        recipe_id: recipe_id,
        product_in_storage: serialize_products
      }
    end

    private

    def serialize_products
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
