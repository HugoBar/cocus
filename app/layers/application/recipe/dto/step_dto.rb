module Application
  module Recipe
    module Dto
      # Data Transfer Object representing a single preparation step
      # within a recipe, as exposed by the application layer.
      #
      # This DTO is a lightweight, presentation‑friendly representation
      # of the domain Step value object. Its sole purpose is to transport
      # data from the domain layer to the interface layer (e.g., serializers,
      # API responses).
      #
      # Example usage:
      #   step_dto = StepDto.from_domain(step)
      #
      #   step_dto.description # => "Mix ingredients"
      #   step_dto.position    # => 1
      class StepDto
        attr_reader :description, :position

        # Initializes a new StepDto.
        #
        # @param description [String] the instruction text for this step
        # @param position [Integer] the step's order within the recipe
        def initialize(description:, position:)
          @description = description
          @position = position
        end

        # Builds a StepDto from a domain Step value object.
        #
        # This method extracts only the data required for presentation.
        #
        # @param step [Domains::Recipe::Step] the domain step value object
        # @return [StepDto] a fully populated DTO
        #
        # Example:
        #   dto = StepDto.from_domain(step)
        def self.from_domain(step)
          new(
            description: step.description,
            position: step.position
          )
        end
      end
    end
  end
end
