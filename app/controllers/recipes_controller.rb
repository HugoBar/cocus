class RecipesController < ApplicationController
  before_action :recipe_exists?, only: :complete_recipe

  # GET /recipes
  def index
    recipes = Recipes::RecipeService.new.all

    render json: Recipes::RecipeSerializer.serialize_collection(recipes)
  end

  # GET /recipes/1
  def show
    recipe = Recipes::RecipeService.new.find(params[:id])

    render json: Recipes::RecipeSerializer.new(recipe).as_json
  end

  # POST /recipes
  def create
    recipe = Recipes::RecipeService.new.create(recipe_params)

    render json: recipe, status: :created, location: recipe
  end

  # PATCH/PUT /recipes/1
  def update
    recipe = Recipes::RecipeService.new.update(params[:id], recipe_params)

    render json: Recipes::RecipeSerializer.new(recipe).as_json
  end

  # DELETE /recipes/1
  def destroy
    recipe = Recipes::RecipeService.new.destroy(params[:id])
  end

  # GET /recipes/available_recipes
  def available_recipes
    recipes = Recipes::RecipeTrackerService.new.available_recipes(include_unavailable: include_unavailable)

    render json: Recipes::AvailableRecipeSerializer.serialize_collection(recipes)
  end

  # POST /recipes/complete_recipe
  def complete_recipe
    completion = Recipes::RecipeTrackerService.new.complete_recipe(complete_recipe_params)

    render json: Recipes::CompleteRecipeSerializer.new(completion).as_json
  rescue Unitwise::ConversionError => e
    render json: { error: e.message }, status: :bad_request
  end

  private

  def recipe_exists?
    recipe = Recipe.find_by(id: params[:recipe][:id])
    
    unless recipe
      render json: { error: "Recipe not found" }, status: :not_found
    end
  end

  # Only allow a list of trusted parameters through.
  def recipe_params
    rp = params.require(:recipe).permit( 
      :name, :description, :prep_time, :servings, 
      steps: [], 
      ingredients: [:product_id, :quantity, :unit] 
    )

    rp[:recipe_products_attributes] = rp.delete(:ingredients) if rp[:ingredients]

    rp
  end

  def complete_recipe_params
    params.require(:recipe).permit( 
      :id,
      ingredients: [:product_id, :quantity, :unit] 
    )
  end

  def include_unavailable
    params[:include_unavailable].to_s.downcase == "true"
  end
end
