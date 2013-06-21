class AddTrigramIndexToNames < ActiveRecord::Migration
  def up 
    execute "CREATE INDEX idx_trgm_on_name_words on names USING gin (term gin_trgm_ops)"
  end
  def down
    execute "DROP INDEX idx_trgm_on_names"
  end
end
