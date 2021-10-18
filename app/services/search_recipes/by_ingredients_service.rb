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
      return [] if ingredients.blank?

      mapped_ingredients = splitted_ingredients.map do |ingredient|
        Recipe.joins(:ingredients).select(:id).where(
          "to_tsvector('fr', ingredients.name) @@ phraseto_tsquery('fr ', ?)",
          ingredient
        ).to_sql
      end

      query = "(#{mapped_ingredients.join(') INTERSECT (')}) LIMIT #{limit}"

      results = ActiveRecord::Base.connection.execute(query)

      Recipe.find(results.map { |result| result['id'] })
    end

    private

    def splitted_ingredients
      ingredients.split(',').map(&:squish)
    end
  end
end
