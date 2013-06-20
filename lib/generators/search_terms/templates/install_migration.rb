class <%= migration_class_name %> < ActiveRecord::Migration
  def up
     if select_value(%Q{select extname from pg_extension where extname = 'pg_trgm'}).nil?
       execute "CREATE EXTENSION PG_TRGM"
     end
  end

  def down
    execute "DROP EXTENSION PG_TRGM"
  end
end
