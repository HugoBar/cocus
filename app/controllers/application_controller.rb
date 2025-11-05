class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordInvalid,       with: :handle_record_invalid
  rescue_from ActiveRecord::RecordNotUnique,     with: :handle_record_not_unique
  rescue_from ActionController::ParameterMissing, with: :handle_parameter_missing
  rescue_from ActiveRecord::RecordNotFound,      with: :handle_record_not_found
  rescue_from StandardError,                     with: :handle_internal_error unless Rails.env.development?

  private

  def handle_record_invalid(exception)
    record = exception.record

    if record.is_a?(Product) && record.errors.added?(:name, :taken)
      render json: { error: "Product already exists" }, status: :conflict
    else
      render json: {
        error: "Validation failed",
        details: record.errors
      }, status: :unprocessable_entity
    end
  end

  def handle_record_not_unique(_exception)
    render json: { error: "Product already exists" }, status: :conflict
  end

  def handle_parameter_missing(exception)
    render json: {
      error: "Missing required parameter",
      details: exception.message
    }, status: :bad_request
  end

  def handle_record_not_found(exception)
    render json: {
      error: "Record not found",
      details: exception.message
    }, status: :not_found
  end

  def handle_internal_error(exception)
    render json: {
      error: "Internal server error",
      details: exception.message
    }, status: :internal_server_error
  end
end
