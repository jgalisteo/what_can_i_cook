class CreateCustomDictionary < ActiveRecord::Migration[6.1]
  def up
    execute 'CREATE EXTENSION unaccent'

    execute 'CREATE TEXT SEARCH CONFIGURATION fr (COPY = french)'

    execute <<-SQL.squish
      ALTER TEXT SEARCH CONFIGURATION fr
        ALTER MAPPING FOR hword, hword_part, word
        WITH unaccent, french_stem
    SQL
  end

  def down
    execute 'DROP TEXT SEARCH CONFIGURATION fr'

    execute 'DROP EXTENSION unaccent'
  end
end
