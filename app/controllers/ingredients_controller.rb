class IngredientsController < ApplicationController
	before_action :authenticate_user!
	before_action :set_ingredient, except: [:index, :new, :create]

	def index
		@ingredients = current_user.ingredients
	end

<<<<<<< HEAD
	def show
		# @ingredient already set by before_action
	end
=======
  def show 
  end
>>>>>>> dce5913b36f398dcdd2856307cc9fbe16fc33cbb

	def new
		@ingredient = current_user.ingredients.build
	end

	def create
		@ingredient = current_user.ingredients.build(ingredient_params)
		if @ingredient.save
			redirect_to @ingredient, notice: 'Ingredient was successfully created.'
		else
			render :new, status: :unprocessable_entity
		end
	end

	def edit
		# @ingredient already set by before_action
	end

	def update
		if @ingredient.update(ingredient_params)
			redirect_to ingredients_path, notice: 'Ingredient was successfully updated.'
		else
			render :edit
		end
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
