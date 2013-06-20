migration <%= migration_number.to_i %>, :<%= migration_file_name %> do 
  up do
    execute "CREATE INDEX <%=index_name %> on <%=table_name %> USING gin (term gin_trgm_ops)"
  end
  down do
    execute "DROP INDEX <%=index_name %>"
  end
end
