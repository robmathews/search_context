class AddTrigramIndexToSearchTerms < ActiveRecord::Migration
  def up 
    execute "CREATE INDEX idx_trgm_on_search_terms on search_terms USING gin (term gin_trgm_ops)"
  end
  def down
    execute "DROP INDEX idx_trgm_on_search_terms"
  end
end
