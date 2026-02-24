module Domains
  module Product
    class ProductRepository
      def find(id)
        raise NotImplementedError
      end

      def all
        raise NotImplementedError
      end
    end
  end
end
