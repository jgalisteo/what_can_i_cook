class SearchRecipesController < ApplicationController
  def index
    service = SearchRecipes::ByIngredientsService.new(ingredients_params)

    if service.valid?
      @recipes = service.execute
    else
      @errors = service.errors
    end
  end

  private

  def ingredients_params
    params.permit(:ingredients)
  end
end
