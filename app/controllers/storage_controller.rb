class StorageController < ApplicationController
  before_action :set_storage_params, only: [ :add_product_to_storage, :remove_product_from_storage ]
  before_action :product_exists?, only: [ :add_product_to_storage, :remove_product_from_storage ]
  before_action :validate_measure_unit, only: [ :add_product_to_storage, :remove_product_from_storage ]

  # GET /storage
  def index
    storages = Storages::StorageService.new.all

    render json: Storages::StorageSerializer.serialize_collection(storages)
  end

  # GET /storage/1
  def show
    storage = Storages::StorageService.new.find(params[:id])

    render json: Storages::StorageSerializer.new(storage).as_json
  end

  # POST /add_product_to_storage
  def add_product_to_storage
    storage = Storages::StorageService.new.add_product_to_storage(@storage_params)

    render json: storage, status: :created, location: storage
  end

  # POST /remove_product_from_storage
  def remove_product_from_storage
    storage = Storages::StorageService.new.remove_product_from_storage(@storage_params)

    render json: Storages::StorageSerializer.new(storage).as_json
  end

  # PATCH/PUT /storage/1
  def update
    storage = Storages::StorageService.new.update(params[:id], product_params)

    render json: Storages::StorageSerializer.new(storage).as_json
  end

  private

  def set_storage_params
    @storage_params = storage_params_with_validation
  end

  def product_exists?
    product = Product.find(@storage_params[:product_id])
  end

  def validate_measure_unit
    ensure_measure_unit!(@storage_params)
  end

  def product_params
    params.require(:product).permit(:product_id, :quantity)
  end
end
