class AddDensityToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :density, :float
  end
end
