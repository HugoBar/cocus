class StorageController < ApplicationController
  before_action :product_exists?, only: :create
  before_action :validate_unit, only: [:create]

  ALLOWED_UNITS = %w[kg g l ml tablespoon teaspoon cup count].freeze

  # GET /storage
  def index
    storage = Storages::StorageService.new.all

    render json: storage
  end

  # POST /storage
  def create
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
