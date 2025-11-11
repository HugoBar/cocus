class ProductsController < ApplicationController
  before_action :set_product_params, only: [:create]
  before_action :validate_measure_unit, only: [:create]

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
    product = Products::ProductService.new.create(@product_params)

    render json: product, status: :created, location: product
  end

  # PATCH/PUT /products/1
  def update
     product = Products::ProductService.new.update(params[:id], product_params)

    render json: Products::ProductSerializer.new(product).as_json
  end

  # DELETE /products/1
  def destroy
    product = Products::ProductService.new.destroy(params[:id])
  end


  private

  def set_product_params
    @product_params = product_params_with_validation
  end

  def validate_measure_unit
    ensure_measure_unit!(@product_params)
  end

    # Only allow a list of trusted parameters through.
    def product_params
      params.require(:product).permit(:name, :unit)
    end
end
