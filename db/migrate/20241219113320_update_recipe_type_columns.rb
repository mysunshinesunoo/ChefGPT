class UpdateRecipeTypeColumns < ActiveRecord::Migration[7.2]
  def change
    remove_column :recipes, :type, :string
    
    add_column :recipes, :recipe_type, :string
  end
end
