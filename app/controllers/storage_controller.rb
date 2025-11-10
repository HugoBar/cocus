class StorageController < ApplicationController
  before_action :product_exists?, only: :add_product_to_storage
  before_action :validate_unit, only: [:add_product_to_storage]

  ALLOWED_UNITS = %w[kg g l ml tablespoon teaspoon cup count].freeze

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
    storage = Storages::StorageService.new.add_product_to_storage(storage_params)

    render json: storage, status: :created, location: storage
  rescue Unitwise::ConversionError => e
    render json: { error: e.message }, status: :bad_request
  end

  private
  
  def product_exists?
    product = Product.find_by(id: params[:product_id])
    unless product
      render json: { error: "Product not found" }, status: :not_found
    end
  end

  # Only allow a list of trusted parameters through.
  def storage_params
    params.expect(storage: [ :product_id, :quantity, :unit ])
  end

  def validate_unit
    unit = params.dig(:storage, :unit)
    unless ALLOWED_UNITS.include?(unit)
      render json: { error: "Invalid unit. Allowed units are: #{ALLOWED_UNITS.join(', ')}" }, status: :unprocessable_entity
    end
  end
end
