migration <%= migration_number.to_i %>, :<%= migration_file_name %> do 
  up do
     execute "CREATE EXTENSION PG_TRGM"
  end

  down do
    execute "DROP EXTENSION PG_TRGM"
  end
end
