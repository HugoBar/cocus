class RecipesController < ApplicationController
  before_action :set_recipe_params, only: :create
  before_action :set_complete_recipe_params, only: :complete_recipe

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
    recipe = Recipes::RecipeService.new.create(@recipe_params)

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

  # POST /recipes/1/complete
  def complete_recipe
    completion = Recipes::RecipeTrackerService.new.complete_recipe(params[:id], @complete_recipe_params)

    render json: Recipes::CompleteRecipeSerializer.new(completion).as_json
  end

  private

  def set_recipe_params
    @recipe_params = recipe_params_with_validations
    ensure_measure_unit!(@recipe_params)
  end

  def set_complete_recipe_params
    @complete_recipe_params = complete_recipe_params_with_validations
    ensure_measure_unit!(@complete_recipe_params)
  end

  def include_unavailable
    params[:include_unavailable].to_s.downcase == "true"
  end
end
