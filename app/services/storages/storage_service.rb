module Storages
  class StorageService
    def all
      Storage.includes(:product).all
    end

    def find(id)
      Storage.includes(:product).find(id)
    end 

    def add_product_to_storage(product)
      storage = Storage.find_or_initialize_by(product_id: product[:product_id])
      current_quantity = storage[:quantity] || 0
      added_quantity   = UnitConverter.to_base(product[:quantity], product[:unit], storage.product)
      updated_quantity = current_quantity + added_quantity

      storage.update(quantity: updated_quantity, unit: storage.product.unit)
      storage
    end

    def remove_from_storage(product)
      storage = Storage.find_by(product_id: product[:product_id])
      
      removed_quantity = UnitConverter.to_base(product[:quantity], product[:unit], storage.product)
      updated_quantity = [storage[:quantity] - removed_quantity, 0].max

      storage.update(quantity: updated_quantity, unit: storage.product.unit)
      storage
    end

    def remove_batch(products)
      updated_storage = []

      ActiveRecord::Base.transaction do
        products.each do |p|
          updated_storage  << remove_from_storage(p)
        end
      end

      updated_storage
    end
  end
end