module SearchRecipes
  class ByIngredientsService
    include ActiveModel::Model
    include ActiveModel::Attributes
    include ActiveModel::Validations

    MAX_INGREDIENTS = 20
    MAX_RECIPES = 10

    attribute :ingredients, :string, default: ''
    attribute :limit, :integer, default: MAX_RECIPES

    validates_each :splitted_ingredients do |record, _, value|
      if value.size > MAX_INGREDIENTS
        record.errors.add(
          :ingredients,
          "You exceeded the max amount of ingredients (max: #{MAX_INGREDIENTS})"
        )
      end
    end

    def execute
      return Recipe.none if ingredients.blank?

      query.group(:id)
           .order("COUNT(#{Recipe.table_name}.id) DESC")
           .order("#{Recipe.table_name}.rate DESC NULLS LAST")
           .limit(limit)
    end

    private

    def query
      splitted_ingredients.map { |ingredient|
        Recipe.joins(:ingredients).where(
          "to_tsvector('fr', ingredients.name) @@ phraseto_tsquery('fr ', ?)",
          ingredient
        )
      }.reduce(:or)
    end

    def splitted_ingredients
      ingredients.split(',').map(&:squish)
    end
  end
end
