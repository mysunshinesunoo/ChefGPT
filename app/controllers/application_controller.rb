class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :set_user_stats, if: :user_signed_in?

  private

  def set_user_stats
    @user_stats = {
      recipes: current_user.recipes.count,
      favorites: current_user.recipes.where(is_favorite: true).count,
      ingredients: current_user.ingredients.count
    }
  end
end
