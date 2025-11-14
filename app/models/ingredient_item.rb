class IngredientItem
  attr_reader :product, :quantity, :unit

  def initialize(product, quantity, unit)
    @product = product
    @quantity = quantity
    @unit = unit
  end
end
