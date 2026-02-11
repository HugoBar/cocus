module Domains
  module Shared
    # Mixin module to define Value Objects (VOs).
    #
    # A Value Object is an immutable object whose equality is determined
    # by its attributes rather than object identity.
    #
    # To use, include this module in your class and define which attributes
    # determine equality via `equality_attributes`.
    #
    # Example usage:
    #   class Step
    #     include Domains::Shared::ValueObject
    #     equality_attributes :description, :position
    #   end
    #
    # Then instances of Step will be compared by `description` and `position`:
    #   step1 == step2
    module ValueObject
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        # Defines which attributes are used to determine equality for the VO.
        # @param attrs [Array<Symbol>] attribute names
        def equality_attributes(*attrs)
          @equality_attributes = attrs.map(&:to_s).map { |a| "@#{a}".to_sym }
        end

        # Returns the list of equality attributes
        def _equality_attributes
          @equality_attributes
        end
      end

      # Compares two VOs for equality based on the defined equality attributes
      #
      # @param other [Object] another object to compare
      # @return [Boolean] true if the objects are equal based on equality attributes
      def ==(other)
        return false unless other.is_a?(self.class)
        
        # use defined equality attributes or all instance variables if none defined
        attrs_to_compare = self.class._equality_attributes || instance_variables
        attrs_to_compare.all? do |var|
          instance_variable_get(var) == other.instance_variable_get(var)
        end
      end
      alias eql? ==

      # Returns a hash value for the VO based on its equality attributes
      #
      # @return [Integer] hash value
      def hash
        attrs_to_compare = self.class._equality_attributes || instance_variables
        values = attrs_to_compare.map { |var| instance_variable_get(var) }
        [self.class, *values].hash
      end
    end
  end
end
