class AddIsFavoriteToRecipes < ActiveRecord::Migration[7.2]
  def change
    add_column :recipes, :is_favorite, :boolean
  end
end
