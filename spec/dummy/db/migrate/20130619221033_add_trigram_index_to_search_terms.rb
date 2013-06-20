migration 20130619221033, :add_trigram_index_to_search_terms do 
  up do
    execute "CREATE INDEX idx_trgm_on_search_terms on search_terms USING gin (term gin_trgm_ops)"
  end
  down do
    execute "DROP INDEX idx_trgm_on_search_terms"
  end
end
