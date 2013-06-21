class AddNamesTsearchIndexToAuthors < ActiveRecord::Migration
  def up 
    execute "CREATE INDEX idx_names_vector_on_authors on authors USING gin (names_vector)"
  end
  def down
    execute "DROP INDEX idx_names_vector_on_authors"
  end
end
