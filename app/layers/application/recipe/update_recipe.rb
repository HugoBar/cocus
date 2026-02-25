module Application
  module Recipe
    # Application use case responsible for updating a recipe.
    #
    # It coordinates domain repositories but does not contain
    # business rules itself.
    class UpdateRecipe
      # Initializes the use case with required dependencies.
      #
      # @param recipe_repository [Domains::Recipe::RecipeRepository]
      # @param product_repository [Domains::Product::ProductRepository]
      def initialize(recipe_repository:, product_repository:)
        @recipe_repository = recipe_repository
        @product_repository = product_repository
      end

      # Executes the use case.
      #
      # Updates the recipe and loads the products referenced
      # by the recipe's ingredients.
      #
      # @param id [Integer] the ID of the recipe to update
      # @param attributes [Hash] the attributes to update on the recipe
      # @return [Hash] containing:
      #   - :recipe [Application::Recipe::Dto::RecipeDto]
      #   - :products [Array<Application::Product::Dto::ProductDto>]
      def call(id:, attributes:)
        recipe = @recipe_repository.update(id, attributes)
        products = @product_repository.find_by_ids(recipe.ingredients.map(&:product_id))

        recipe_dto = Dto::RecipeDto.from_domain(recipe)
        product_dtos = products.map { |product| Product::Dto::ProductDto.from_domain(product) }

        { recipe: recipe_dto, products: product_dtos }
      end
    end
  end
end