RSpec.describe SearchRecipes::ByIngredientsService do
  describe '#execute' do
    let(:common_ingredient_name) { 'Ingredient' }

    describe 'Basic search' do
      before do
        @recipe = create(:recipe)
        @ingredient = create(:ingredient, recipe: @recipe)
        create(:ingredient, name: common_ingredient_name, recipe: @recipe)

        @another_recipe = create(:recipe)
        @another_ingredient = create(:ingredient, recipe: @another_recipe)
        create(:ingredient, name: common_ingredient_name, recipe: @another_recipe)
      end

      it 'returns recipes' do
        result = described_class.new(ingredients: @ingredient.name).execute

        expect(result).to match_array([@recipe])
      end

      context 'with shared ingredients' do
        it 'returns recipes' do
          result = described_class.new(ingredients: common_ingredient_name).execute

          expect(result).to match_array([@recipe, @another_recipe])
        end
      end

      context 'with different ingredients' do
        it 'returns empty' do
          result = described_class.new(
            ingredients: [@ingredient.name, @another_ingredient.name].join(',')
          ).execute

          expect(result).to eq([])
        end
      end

      context 'with empty input' do
        it 'returns empty' do
          result = described_class.new(ingredients: '').execute

          expect(result).to eq([])
        end
      end

      context 'with nil input' do
        it 'returns empty' do
          result = described_class.new(ingredients: nil).execute

          expect(result).to eq([])
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

        expect(result.count).to eq(10)
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
