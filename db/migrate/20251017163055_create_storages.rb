class CreateStorages < ActiveRecord::Migration[8.0]
  def change
    create_table :storages do |t|
      t.references :product, null: false, foreign_key: true
      t.decimal :quantity
      t.string :unit

      t.timestamps
    end
  end
end
