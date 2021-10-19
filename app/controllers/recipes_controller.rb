class RecipesController < ApplicationController
  # GET /recipes/1
  def show
    @recipe = Recipe.includes(:ingredients).find(params[:id])
  end
end
