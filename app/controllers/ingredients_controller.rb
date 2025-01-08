class IngredientsController < ApplicationController
	before_action :set_ingredient, except: [:index, :create]

	def index
		@ingredients = Ingredient.all
	end

  def show 
  end

	def new
    @ingredient = Ingredient.new
  end

  def create
    @ingredient = Ingredient.new(ingredient_params)
		if @ingredient.save
      redirect_to ingredients_path, notice: 'Ingredient was successfully created.'
    else
      render :new
    end
	end

	def edit
    @ingredient = Ingredient.find(params[:id])
	end

	def destroy
    @ingredient.destroy
    redirect_to ingredients_path, notice: 'Ingredient was successfully destroyed.'
	end

	private
  
	def ingredient_params
    params.require(:ingredient).permit(:name, :quantity)
  end

	def set_ingredient
    @ingredient = Ingredient.find(params[:id])
  end

end
