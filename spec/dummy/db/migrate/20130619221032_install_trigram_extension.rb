migration 20130619221032, :install_trigram_extension do 
  up do
     if select_value(%Q{select extname from pg_extension where extname = 'pg_trgm'}).nil?
       execute "CREATE EXTENSION PG_TRGM"
     end
  end

  down do
    execute "DROP EXTENSION PG_TRGM"
  end
end
