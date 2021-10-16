class AddIndexToIngredientsName < ActiveRecord::Migration[6.1]
  def up
    execute <<-SQL.squish
      CREATE INDEX fr_dict_name_idx ON ingredients USING GIN (to_tsvector('fr', name))
    SQL
  end

  def down
    execute 'DROP INDEX fr_dict_name_idx'
  end
end
