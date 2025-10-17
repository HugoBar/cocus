class ProductsController < ApplicationController

  # GET /products
  def index
    products = Products::ProductService.new.all

    render json: Products::ProductSerializer.serialize_collection(products)
  end

  # GET /products/1
  def show
    product = Products::ProductService.new.find(params[:id])

    render json: Products::ProductSerializer.new(product).as_json
  end

  # POST /products
  def create
    product = Products::ProductService.new.create(product_params)

    if product.save
      render json: product, status: :created, location: product
    else
      render json: product.errors, status: :unprocessable_content
    end
  end

  # PATCH/PUT /products/1
  def update
     product = Products::ProductService.new.update(params[:id], product_params)

    if product
      render json: Products::ProductSerializer.new(product).as_json
    else
      render json: product.errors, status: :unprocessable_content
    end
  end

  # DELETE /products/1
  def destroy
    product = Products::ProductService.new.destroy(params[:id])
  end


  private
    # Only allow a list of trusted parameters through.
    def product_params
      params.require(:product).permit(:name)
    end
end
