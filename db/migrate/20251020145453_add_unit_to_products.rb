class AddUnitToProducts < ActiveRecord::Migration[8.0]
  def change
    add_column :products, :unit, :string
  end
end
