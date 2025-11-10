class StorageController < ApplicationController
  before_action :set_storage_params, only: :add_product_to_storage
  before_action :product_exists?, only: :add_product_to_storage
  before_action :validate_measure_unit, only: [:add_product_to_storage]

  # GET /storage
  def index
    storages = Storages::StorageService.new.all

    render json: Storages::StorageSerializer.serialize_collection(storages)
  end

  # GET /storage/1
  def show
    recipe = Storages::StorageService.new.find(params[:id])

    render json: Storages::StorageSerializer.new(recipe).as_json
  end

  # POST /storage
  def add_product_to_storage
    storage = Storages::StorageService.new.add_product_to_storage(@storage_params)

    render json: storage, status: :created, location: storage
  end

  private
  
  def set_storage_params
    @storage_params = storage_params_with_validation
  end

  def product_exists?
    product = Product.find(@storage_params[:product_id])
  end

  def validate_measure_unit
    unit = @storage_params[:unit]

    unless ALLOWED_UNITS.include?(unit)
      raise InvalidMeasureUnitError
    end
  end
end
