namespace :db do
  desc 'populate database with recipes'
  task :insert_json_recipes, [:filepath] => :environment do |_, args|
    filepath = args.filepath

    unless File.exist?(filepath)
      puts "No such file or directory #{filepath}"

      next
    end

    File.readlines(filepath).each do |line|
      params = JSON.parse(line)

      recipe = Recipe.create(
        name: params['name'],
        preparation_time: params['prep_time'],
        cook_time: params['cook_time'],
        total_time: params['total_time'],
        people: params['people_quantity'],
        difficulty: params['difficulty'],
        rate: params['rate'],
        image: params['image']
      )

      recipe.ingredients.insert_all(params['ingredients'].map do |ingredient|
        {name: ingredient, created_at: recipe.created_at, updated_at: recipe.created_at}
      end)
    end
  end
end
