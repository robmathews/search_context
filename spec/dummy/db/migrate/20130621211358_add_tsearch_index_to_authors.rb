class AddTsearchIndexToAuthors < ActiveRecord::Migration
  def up 
    execute "CREATE INDEX idx_search_terms_vector_on_authors on authors USING gin (search_terms_vector)"
  end
  def down
    execute "DROP INDEX idx_search_terms_vector_on_authors"
  end
end
