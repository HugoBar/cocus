module Application
  module Recipe
    class GetRecipe
      def initialize(recipe_repository:)
        @recipe_repository = recipe_repository
      end

      def call(id:)
        @recipe_repository.find(id)
      end
    end
  end
end
