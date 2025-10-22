module Storages
  class StorageService
    def all
      ::Storage.includes(:product).all
    end

    def add_product_to_storage(params)
      storage = ::Storage.find_or_initialize_by(product_id: params[:product_id])

      unless storage.product.unit == params[:unit]
        raise ArgumentError, "Expected #{storage.product.unit}, got #{params[:unit]}"
      end

      current_quantity = storage[:quantity] || 0

      storage.update(quantity: current_quantity + params[:quantity], unit: params[:unit])
      storage
    end
  end
end