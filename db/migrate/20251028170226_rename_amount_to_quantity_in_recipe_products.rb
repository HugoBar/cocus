class RenameAmountToQuantityInRecipeProducts < ActiveRecord::Migration[8.0]
  def change
    rename_column :recipe_products, :amount, :quantity
  end
end
