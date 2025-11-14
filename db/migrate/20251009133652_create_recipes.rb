class CreateRecipes < ActiveRecord::Migration[8.0]
  def change
    create_table :recipes do |t|
      t.string  :name, null: false
      t.text    :description
      t.integer :prep_time
      t.integer :servings
      t.json    :steps

      t.timestamps
    end
  end
end
