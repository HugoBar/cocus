module Application
  module Recipe
    # Application use case responsible for retrieving all recipes
    # along with their associated products.
    #
    # It coordinates domain repositories but does not contain
    # business rules itself.
    class GetAllRecipes
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
      # Loads all recipes and, for each recipe, loads the products referenced
      # by the recipe's ingredients.
      #
      # @return [Hash] containing:
      #   - :recipes [Array<Application::Recipe::Dto::RecipeDto>]
      #   - :products_per_recipe [Array<Array<Application::Product::Dto::ProductDto>>]
      def call
        recipes = @recipe_repository.all
        products_per_recipe = recipes.map do |recipe|
          @product_repository.find_by_ids(recipe.ingredients.map(&:product_id))
        end

        {
          recipes: recipes.map { |recipe| Dto::RecipeDto.from_domain(recipe) },
          products_per_recipe: products_per_recipe.map do |products|
            products.map { |p| Product::Dto::ProductDto.from_domain(p) }
          end
        }
      end
    end
  end
end
