require 'unitwise'

class UnitConverter
  def self.to_base(value, unit, product)
    if ["tablespoon", "teaspoon", "cup"].include?(unit) && product.unit === "g"
      # Convert volume units to weight base
      volume_ml = Unitwise(value, unit).convert_to("mL").value
      volume_ml * product.density
    elsif unit == "pcs"
      value
    else
      # Regular unit conversion
      Unitwise(value, unit).convert_to(product.unit).value
    end
  end
end
