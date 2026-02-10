module Domain
  module Recipe
    require_relative 'errors'

    # Represents a single step in a recipe.
    #
    # Step is a Value Object (VO), meaning it is immutable and represents
    # an atomic piece of data in a recipe.
    #
    # Each step has a description of the action and a position indicating
    # its order in the recipe.
    #
    # Example usage:
    #   step = Domain::Recipe::Step.new(
    #     description: "Mix ingredients in a bowl",
    #     position: 1
    #   )
    class Step
      include Domain::Shared::ValueObject

      # Attributes used to determine equality for the Value Object
      equality_attributes :description, :position

      attr_reader :description, :position

      # Initializes a new Step object.
      #
      # @param description [String] the text describing the step
      # @param position [Integer] the step's order in the recipe
      def initialize(description:, position:)
        @description = description
        @position = position.to_i

        validate! # ensure the step is valid
        freeze    # immutability for VO
      end

      private

      # Validates the step's attributes
      #
      # @raise [InvalidStepError] if any validation fails
      def validate!
        # Validate description presence and length
        raise InvalidStepError, "description cannot be blank" if description.nil? || description.strip.empty?
        raise InvalidStepError, "description must be under 1000 characters" if description.length > 1000
        raise InvalidStepError, "description must be at least 3 characters" if description.length < 3

        # Validate position
        raise InvalidStepError, "position must be positive" if position <= 0
        raise InvalidStepError, "position cannot exceed 999" if position > 999
      end
    end
  end
end
