module Application
  module Recipe
    # Application use case responsible for creating a recipe.
    #
    # It coordinates domain repositories but does not contain
    # business rules itself.
    class CreateRecipe
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
      # Creates the recipe and loads the products referenced
      # by the recipe's ingredients.
      #
      # @param attributes [Hash] the attributes for the new recipe
      # @return [Hash] containing:
      #   - :recipe [Application::Recipe::Dto::RecipeDto]
      #   - :products [Array<Application::Product::Dto::ProductDto>]
      def call(attributes)
        recipe = @recipe_repository.create(attributes)
        products = @product_repository.find_by_ids(recipe.ingredients.map(&:product_id))

        recipe_dto = Dto::RecipeDto.from_domain(recipe)
        product_dtos = products.map { |product| Product::Dto::ProductDto.from_domain(product) }

        { recipe: recipe_dto, products: product_dtos }
      end
    end
  end
end
