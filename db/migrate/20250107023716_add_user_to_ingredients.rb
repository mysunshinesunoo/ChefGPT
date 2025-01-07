class AddUserToIngredients < ActiveRecord::Migration[7.2]
  def change
    add_reference :ingredients, :user, null: false, foreign_key: true
  end
end
