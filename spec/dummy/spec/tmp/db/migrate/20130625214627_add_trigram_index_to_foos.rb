class AddTrigramIndexToFoos < ActiveRecord::Migration
  def up 
    execute "CREATE INDEX idx_trgm_on_foos on foos USING gin (name gin_trgm_ops)"
  end
  def down
    execute "DROP INDEX idx_trgm_on_foos"
  end
end
