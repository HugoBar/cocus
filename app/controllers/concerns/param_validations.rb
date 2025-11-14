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

    if params[:unit] == "kg" or params[:unit] == "g"
      required_fields = %i[name unit density]
    else
      required_fields = %i[name unit]
    end

    ensure_required_fields!(product, required_fields)

    product
  end

  def recipe_params_with_validations
    recipe = params.require(:recipe).permit(
      :name, :description, :prep_time, :servings,
      steps: [],
      ingredients: [ :product_id, :quantity, :unit ]
    )

    required_fields = %i[name description prep_time servings steps ingredients]
    ensure_required_fields!(recipe, required_fields)

    recipe[:recipe_products_attributes] = recipe.delete(:ingredients)

    recipe
  end

  def complete_recipe_params_with_validations
    recipe = params.require(:recipe).permit(
      ingredients: [ :product_id, :quantity, :unit ]
    )

    required_fields = %i[ingredients]
    ensure_required_fields!(recipe, required_fields)

    recipe[:recipe_products_attributes] = recipe.delete(:ingredients)

    recipe
  end

  # TODO: apply to nested attributes
  def ensure_required_fields!(params, required_fields)
    missing = required_fields.select { |field| params[field].blank? }

    if missing.any?
      raise ActionController::ParameterMissing.new(missing.join(", "))
    end
  end

  def ensure_measure_unit!(params)
    units = if params[:unit]
              [ params[:unit] ]
    else
              params[:recipe_products_attributes]&.map { |p| p[:unit] } || []
    end

    raise InvalidMeasureUnitError unless units.all? { |unit| ALLOWED_UNITS.include?(unit) }
  end
end
