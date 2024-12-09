class CreateRecipes < ActiveRecord::Migration[7.2]
  def change
    create_table :recipes do |t|
      t.string :name
      t.string :type
      t.string :description
      t.string :steps
      t.integer :nutrition_rating
      t.string :prep_time

      t.timestamps
    end
  end
end
