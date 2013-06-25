class AddTrigramIndexToVarietals < ActiveRecord::Migration
  def up 
    execute "CREATE INDEX idx_trgm_on_varietals on varietals USING gin (name gin_trgm_ops)"
  end
  def down
    execute "DROP INDEX idx_trgm_on_varietals"
  end
end
