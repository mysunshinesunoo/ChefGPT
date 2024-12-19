class RecipesController < ApplicationController
  def index
    @recipes = Recipe.all
  end

  def create
    service = OpenaiService.new
    recipes_data = service.generate_recipe(recipe_params[:prompt], recipe_params[:ingredients])
    
    @recipes = recipes_data["recipes"].map do |recipe_data|
      Recipe.create!(
        name: recipe_data["name"],
        recipe_type: recipe_data["type"],
        description: recipe_data["description"],
        steps: recipe_data["steps"],
        nutrition_rating: recipe_data["nutrition_rating"],
        prep_time: recipe_data["prep_time"]
      )
    end

    render json: @recipes
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private

  def recipe_params
    params.require(:recipe).permit(:prompt, ingredients: [])
  end
end 