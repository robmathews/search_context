migration <%= migration_number.to_i %>, :<%= migration_file_name %> do 
  up do
     if select_value(%Q{select extname from pg_extension where extname = 'pg_trgm'}).nil?
       execute "CREATE EXTENSION PG_TRGM"
     end
  end

  down do
    execute "DROP EXTENSION PG_TRGM"
  end
end
