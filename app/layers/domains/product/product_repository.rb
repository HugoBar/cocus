module Domains
  module Product
    class ProductRepository
      def find(id)
        raise NotImplementedError
      end

      def all
        raise NotImplementedError
      end

      def create(attributes)
        raise NotImplementedError
      end

      def update(id, attributes)
        raise NotImplementedError
      end

      def delete(id)
        raise NotImplementedError
      end
    end
  end
end
