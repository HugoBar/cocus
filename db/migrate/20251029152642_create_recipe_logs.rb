class CreateRecipeLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :recipe_logs do |t|
      t.integer :recipe_id, null: false
      t.datetime :completed_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.json :ingredients, null: false, default: []

      t.timestamps
    end
  end
end
