module Storages
  class StorageService
    def all
      ::Storage.includes(:product).all
    end

    def add_product_to_storage(params)
      storage = ::Storage.find_or_initialize_by(product_id: params[:product_id])
      
      current_quantity = storage[:quantity] || 0
      added_quantity   = UnitConverter.to_base(params[:quantity], params[:unit], storage.product)
      updated_quantity = current_quantity + added_quantity

      storage.update(quantity: updated_quantity, unit: storage.product.unit)
      storage
    end
  end
end