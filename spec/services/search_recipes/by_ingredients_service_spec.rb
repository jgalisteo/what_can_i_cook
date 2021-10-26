RSpec.describe SearchRecipes::ByIngredientsService do
  describe '#execute' do
    let(:common_ingredient_name) { 'Ingredient' }

    describe 'Basic search' do
      before do
        @recipe = create(:recipe, rate: nil)
        @ingredient = create(:ingredient, recipe: @recipe)
        create(:ingredient, name: common_ingredient_name, recipe: @recipe)

        @second_recipe = create(:recipe, rate: 5)
        @second_ingredient = create(:ingredient, recipe: @second_recipe)
        create(:ingredient, name: common_ingredient_name, recipe: @second_recipe)

        @third_recipe = create(:recipe, rate: 3)
        create(:ingredient, name: @ingredient.name, recipe: @third_recipe)
        create(:ingredient, name: common_ingredient_name, recipe: @third_recipe)
      end

      it 'returns recipes' do
        result = described_class.new(ingredients: @ingredient.name).execute

        expect(result).to match_array([@recipe, @third_recipe])
      end

      context 'with shared ingredients' do
        it 'returns recipes' do
          result = described_class.new(ingredients: common_ingredient_name).execute

          expect(result).to match_array([@recipe, @second_recipe, @third_recipe])
        end
      end

      context 'with different ingredients' do
        it 'returns recipes' do
          result = described_class.new(
            ingredients: [@ingredient.name, @second_ingredient.name].join(',')
          ).execute

          expect(result).to match_array([@recipe, @second_recipe, @third_recipe])
        end
      end

      context 'with empty input' do
        it 'returns empty' do
          result = described_class.new(ingredients: '').execute

          expect(result).to be_empty
        end
      end

      context 'with nil input' do
        it 'returns empty' do
          result = described_class.new(ingredients: nil).execute

          expect(result).to be_empty
        end
      end

      describe 'Order' do
        it 'ingredients match DESC, rate DESC NULLS LAST' do
          result = described_class.new(
            ingredients: [common_ingredient_name, @ingredient.name].join(',')
          ).execute

          expect(result).to eq([@third_recipe, @recipe, @second_recipe])
        end
      end
    end

    describe 'Limit results' do
      before do
        15.times do
          create(:recipe, ingredients: [build(:ingredient, name: common_ingredient_name)])
        end
      end

      it 'returns ten results maximum' do
        result = described_class.new(ingredients: common_ingredient_name).execute

        expect(result.to_a.count).to eq(10)
      end
    end

    describe 'Too much ingredients' do
      it 'is invalid' do
        ingredients = Array.new(21) { |n| n }.join(',')
        service = described_class.new(ingredients: ingredients)

        expect(service).to be_invalid
        expect(service.errors[:ingredients]).to include(
          'You exceeded the max amount of ingredients (max: 20)'
        )
      end
    end
  end
end
