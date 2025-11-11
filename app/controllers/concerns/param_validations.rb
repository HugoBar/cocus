module ParamValidations
  extend ActiveSupport::Concern
  
  private

  def storage_params_with_validation
    storage = params.require(:storage).permit(:product_id, :quantity, :unit)

    required_fields = %i[product_id quantity unit]
    ensure_required_fields!(storage, required_fields)

    storage
  end

  def product_params_with_validation
    product = params.require(:product).permit(:name, :unit, :density)

    if params[:unit] == 'kg' or params[:unit] == "g"
      required_fields = %i[name unit density]
    else
      required_fields = %i[name unit]
    end

    ensure_required_fields!(product, required_fields)

    product
  end

  def ensure_required_fields!(params, required_fields)
    missing = required_fields.select { |field| params[field].blank? }

    if missing.any?
      raise ActionController::ParameterMissing.new(missing.join(', '))
    end
  end

  def ensure_measure_unit!(params)
    unit = params[:unit]

    raise InvalidMeasureUnitError unless ALLOWED_UNITS.include?(unit)
  end
end
