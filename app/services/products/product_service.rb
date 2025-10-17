module Products
  class ProductService
    def all
      ::Product.all
    end

    def find(id)
      ::Product.find(id)
    end 

    def create(params)
      ::Product.new(params)
    end
    
    def update(id, params)
      product = ::Product.find(id)
      product.update(params)
      product
    end

    def destroy(id)
      product = ::Product.find(id)
      product.destroy
    end
  end
end