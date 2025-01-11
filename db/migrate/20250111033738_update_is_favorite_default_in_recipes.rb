class UpdateIsFavoriteDefaultInRecipes < ActiveRecord::Migration[7.0]
  def up
    # Update existing NULL values to false
    Recipe.where(is_favorite: nil).update_all(is_favorite: false)
    
    # Change the column default and make it not nullable
    change_column_default :recipes, :is_favorite, from: nil, to: false
    change_column_null :recipes, :is_favorite, false
  end

  def down
    change_column_default :recipes, :is_favorite, from: false, to: nil
    change_column_null :recipes, :is_favorite, true
  end
end
