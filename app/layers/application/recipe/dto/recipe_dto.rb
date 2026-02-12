module Application
  module Recipe
    module Dto

      # Data Transfer Object representing a recipe as exposed by the
      # application layer.
      #
      # This DTO contains no business logic. It exists solely to carry
      # structured data from the domain layer to the interface layer
      # (e.g., serializers, controllers, API responses).
      #
      # Example usage:
      #   recipe_dto = Application::Recipe::Dto::RecipeDto.from_domain(recipe)
      #
      #   recipe_dto.name        # => "Pancakes"
      #   recipe_dto.ingredients # => [IngredientDto, ...]
      class RecipeDto
        attr_reader :id, :name, :description, :ingredients, :steps, :servings, :prep_time

        # Initializes a new RecipeDto.
        #
        # @param id [Integer] the recipe's unique identifier
        # @param name [String] the recipe's name
        # @param description [String] a description of the recipe
        # @param ingredients [Array<IngredientDto>] list of ingredient DTOs
        # @param steps [Array<StepDto>] list of step DTOs
        # @param servings [Integer] number of servings
        # @param prep_time [Float] preparation time in minutes
        def initialize(id:, name:, description:, ingredients:, steps:, servings:, prep_time:)
          @id = id
          @name = name
          @description = description
          @ingredients = ingredients
          @steps = steps
          @servings = servings
          @prep_time = prep_time
        end

        # Builds a RecipeDto from a domain Recipe entity.
        #
        # This method extracts only the data needed for presentation
        # and converts nested domain objects into their corresponding
        # DTOs.
        #
        # @param recipe [Domains::Recipe::Recipe] the domain recipe entity
        # @return [RecipeDto] a fully populated DTO
        #
        # Example:
        #   dto = RecipeDto.from_domain(recipe)
        def self.from_domain(recipe)
          new(
            id: recipe.id,
            name: recipe.name,
            description: recipe.description,
            ingredients: recipe.ingredients.map { |i| IngredientDto.from_domain(i) },
            steps: recipe.steps.map { |s| StepDto.from_domain(s) },
            servings: recipe.servings,
            prep_time: recipe.prep_time
          )
        end
      end

    end
  end
end
