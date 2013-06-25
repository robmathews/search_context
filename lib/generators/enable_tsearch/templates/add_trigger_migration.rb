class <%= migration_class_name %> < ActiveRecord::Migration
  def up
    execute <<-EOS
    -- feel free to customize this function if you want to join to columns from another table, for example
    CREATE OR REPLACE FUNCTION <%=trigger_sp_name %>() RETURNS trigger AS $$
    begin
      new.<%=column_name %> :=
      <% sep='';columns.each do |column| -%>
            <%=sep%>setweight(to_tsvector('<%=search_config_name %>', coalesce(new.<%=column %>,'')), 'A')
            <%sep='|| ' -%>
      <% end -%>;
      return new;
    end
    $$ LANGUAGE plpgsql;
    EOS
    execute <<-EOS
    DROP TRIGGER IF EXISTS <%=trigger_name %> ON <%=table_name %>;
    CREATE TRIGGER <%=trigger_name %> BEFORE INSERT OR UPDATE
        ON <%=table_name %> FOR EACH ROW EXECUTE PROCEDURE <%=trigger_sp_name %>();
    EOS
  end
  def down
    execute "DROP TRIGGER <%=trigger_name %>"
    execute "DROP FUNCTION <%=trigger_sp_name %>"
    
  end
end
