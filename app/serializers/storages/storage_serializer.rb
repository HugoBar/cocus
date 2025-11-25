module Storages
  class StorageSerializer
    def initialize(storage)
      @storage = storage
    end

    def as_json
      {
        id: @storage.id,
        product_id: @storage.product_id,
        product_name: @storage.product.name,
        quantity: @storage.quantity,
        unit: @storage.unit
      }
    end

    def self.serialize_collection(storages)
      {
        collection: 
          storages.map do |storage|
            new(storage).as_json
          end
      }
    end
  end
end
