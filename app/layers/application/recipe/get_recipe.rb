module Application
  module Recipe
    # Application use case responsible for retrieving a recipe
    # along with its associated products.
    #
    # It coordinates domain repositories but does not contain
    # business rules itself.
    class GetRecipe
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
      # Fetches the recipe by ID and loads the products referenced
      # by the recipe's ingredients.
      #
      # @param id [Integer] the recipe ID
      # @return [Hash] containing:
      #   - :recipe [Application::Recipe::Dto::RecipeDto]
      #   - :products [Array<Application::Product::Dto::ProductDto>]
      def call(id:)
        recipe = @recipe_repository.find(id)
        products = @product_repository.find_by_ids(recipe.ingredients.map(&:product_id))

        recipe_dto = Dto::RecipeDto.from_domain(recipe)
        product_dtos = products.map { |product| Product::Dto::ProductDto.from_domain(product) }

        { recipe: recipe_dto, products: product_dtos }
      end
    end
  end
end
