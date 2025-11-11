module Products
  class ProductService
    MAPPED_MEASURE_UNITS = {
      ml: "ml",
      l: "ml",
      tablespoon: "ml",
      teaspoon: "ml",
      cup: "ml",
      count: "ml",
      g: "g",
      kg: "g"
    }

    def all
      Product.all
    end

    def find(id)
      Product.find(id)
    end 

    def create(params)
      mapped_params = params.merge(unit: map_measure_unit(params[:unit]))

      Product.create!(mapped_params)
    end
    
    def update(id, params)
      product = Product.find(id)
      product.update(params)
      product
    end

    def destroy(id)
      product = Product.find(id)
      product.destroy
    end

    private

    def map_measure_unit(unit)
      MAPPED_MEASURE_UNITS[unit.to_sym]
    end
  end
end