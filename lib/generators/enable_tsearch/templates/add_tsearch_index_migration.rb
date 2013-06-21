class <%= migration_class_name %> < ActiveRecord::Migration
  def up 
    execute "CREATE INDEX <%=index_name %> on <%=table_name %> USING gin (<%=column_name%>)"
  end
  def down
    execute "DROP INDEX <%=index_name %>"
  end
end
