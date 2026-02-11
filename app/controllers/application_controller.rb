require_relative '../layers/domains/recipe/errors'

class ApplicationController < ActionController::API
  include ParamValidations
  rescue_from ActiveRecord::RecordInvalid,            with: :handle_record_invalid
  rescue_from ActiveRecord::RecordNotUnique,          with: :handle_record_not_unique
  rescue_from ActionController::ParameterMissing,     with: :handle_parameter_missing
  rescue_from ActiveRecord::RecordNotFound,           with: :handle_record_not_found
  rescue_from InvalidMeasureUnitError,                with: :handle_measure_unit_invalid
  rescue_from Unitwise::ConversionError,              with: :handle_conversion_error
  rescue_from Domains::Recipe::InvalidRecipeError,     with: :handle_recipe_invalid
  rescue_from Domains::Recipe::InvalidIngredientError, with: :handle_recipe_invalid_ingredient
  rescue_from Domains::Recipe::InvalidQuantityError,   with: :handle_recipe_invalid_quantity
  rescue_from Domains::Recipe::InvalidStepError,       with: :handle_recipe_invalid_step
  rescue_from StandardError,                          with: :handle_internal_error unless Rails.env.development?

  private

  def handle_record_invalid(exception)
    record = exception.record

    if record.is_a?(Product) && record.errors.added?(:name, :taken)
      render json: { error: "Product already exists" }, status: :conflict
    else
      render json: {
        error: "Validation failed",
        message: record.errors
      }, status: :unprocessable_entity
    end
  end

  def handle_record_not_unique(_exception)
    render json: { error: "Product already exists" }, status: :conflict
  end

  def handle_parameter_missing(exception)
    render json: {
      error: "Missing required parameter",
      message: exception.message
    }, status: :bad_request
  end

  def handle_record_not_found(exception)
    render json: {
      error: "Record not found",
      message: exception.message
    }, status: :not_found
  end

  def handle_internal_error(exception)
    render json: {
      error: "Internal server error",
      message: exception.message
    }, status: :internal_server_error
  end

  def handle_measure_unit_invalid(exception)
    render json: {
      error: "Invalid measure unit",
      message: "Allowed units are: #{ALLOWED_UNITS.join(', ')}"
    }, status: :unprocessable_entity
  end

  def handle_conversion_error(exception)
    render json: {
      error: "Invalid measure unit conversion",
      message: exception.message
    }, status: :bad_request
  end

  def handle_recipe_invalid(exception)
    render json: {
      error: "Invalid recipe",
      message: exception.message
    }, status: :unprocessable_entity
  end

  def handle_recipe_invalid_ingredient(exception)
    render json: {
      error: "Invalid ingredient",
      message: exception.message
    }, status: :unprocessable_entity
  end

  def handle_recipe_invalid_quantity(exception)
    render json: {
      error: "Invalid quantity",
      message: exception.message
    }, status: :unprocessable_entity
  end

  def handle_recipe_invalid_step(exception)
    render json: {
      error: "Invalid step",
      message: exception.message
    }, status: :unprocessable_entity
  end
end
