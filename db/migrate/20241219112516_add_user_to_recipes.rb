class AddUserToRecipes < ActiveRecord::Migration[7.2]
  def change
    add_reference :recipes, :user, null: false, foreign_key: true
  end
end
