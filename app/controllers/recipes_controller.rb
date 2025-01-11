class RecipesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_recipe, only: [:show]

  def index
    @recipes = current_user.recipes
  end

  def new
    @recipe = Recipe.new
    @ingredients = current_user.ingredients.pluck(:name, :quantity)
  end

  def create
    service = OpenaiService.new
    user_ingredients = current_user.ingredients.pluck(:name, :quantity).map do |name, quantity|
      "#{quantity} #{name}"
    end
    
    recipes_data = service.generate_recipe(recipe_params[:prompt], user_ingredients)
    
    @recipes = recipes_data["recipes"].map do |recipe_data|
      # Generate image for each recipe
      image_path = service.generate_image(recipe_data["name"], recipe_data["description"])
      
      current_user.recipes.create!(
        name: recipe_data["name"],
        recipe_type: recipe_data["recipe_type"],
        description: recipe_data["description"],
        steps: recipe_data["steps"],
        nutrition_rating: recipe_data["nutrition_rating"],
        prep_time: recipe_data["prep_time"],
        image: image_path
      )
    end

    redirect_to recipes_path, notice: 'Recipes were successfully generated!'
  rescue => e
    redirect_to new_recipe_path, alert: "Error: #{e.message}"
  end

  def show
    # @recipe already set by before_action
  end

  private

  def recipe_params
    params.require(:recipe).permit(:prompt)
  end

  def set_recipe
    @recipe = current_user.recipes.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to recipes_path, alert: 'Recipe not found.'
  end
end 