class CreateRecipes < ActiveRecord::Migration[6.1]
  def change
    create_table :recipes do |t|
      t.string :name, null: false
      t.integer :people
      t.string :preparation_time, null: false
      t.string :cook_time, null: false
      t.string :total_time, null: false
      t.string :difficulty, null: false
      t.integer :rate
      t.string :image

      t.timestamps
    end
  end
end
