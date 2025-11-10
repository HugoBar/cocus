module ParamValidations
  extend ActiveSupport::Concern
  
  private

  def storage_params_with_validation
    storage = params.require(:storage).permit(:product_id, :quantity, :unit)

    required_fields = %i[product_id quantity unit]
    ensure_required_fields!(storage, required_fields)

    storage
  end

  def ensure_required_fields!(params, required_fields)
    missing = required_fields.select { |field| params[field].blank? }

    if missing.any?
      raise ActionController::ParameterMissing.new(missing.join(', '))
    end
  end
end
