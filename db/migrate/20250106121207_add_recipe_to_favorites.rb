class AddRecipeToFavorites < ActiveRecord::Migration[7.2]
  def change
    add_reference :favorites, :recipe, null: false, foreign_key: true
  end
end
