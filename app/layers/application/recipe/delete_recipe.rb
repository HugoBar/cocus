module Application
  module Recipe
    # Application use case responsible for deleting a recipe.
    #
    # It coordinates domain repositories but does not contain
    # business rules itself.
    class DeleteRecipe
      # Initializes the use case with required dependencies.
      #
      # @param recipe_repository [Domains::Recipe::RecipeRepository]
      # @param product_repository [Domains::Product::ProductRepository]
      def initialize(recipe_repository:, product_repository:)
        @recipe_repository = recipe_repository
        @product_repository = product_repository
      end

      # Executes the use case.
      # Deletes the recipe with the given ID.
      # @param id [Integer] the unique identifier of the recipe to delete
      # @return [Hash] containing:
      #   - :success [Boolean] whether the deletion was successful
      # @raise ActiveRecord::RecordNotFound if the recipe does not exist
      def call(id:)
        recipe = @recipe_repository.delete(id)
        products = @product_repository.find_by_ids(recipe.ingredients.map(&:product_id))

        recipe_dto = Dto::RecipeDto.from_domain(recipe)
        product_dtos = products.map { |product| Product::Dto::ProductDto.from_domain(product) }

        { recipe: recipe_dto, products: product_dtos }
      end
    end
  end
end
