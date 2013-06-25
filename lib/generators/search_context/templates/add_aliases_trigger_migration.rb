class <%= migration_class_name %> < ActiveRecord::Migration
  def up
    execute <<-EOS
    CREATE OR REPLACE FUNCTION <%=trigger_sp_name %>() RETURNS trigger AS $$
    begin
      new.original_tsquery = plainto_tsquery('<%=search_config_name %>', coalesce(new.original,''));
      new.substitution_tsquery = plainto_tsquery('<%=search_config_name %>', coalesce(new.substitution,''));
      return new;
    end
    $$ LANGUAGE plpgsql;
    EOS
    execute <<-EOS
    DROP TRIGGER IF EXISTS <%=trigger_name %> ON <%=aliases_name %>;
    CREATE TRIGGER <%=trigger_name %> BEFORE INSERT OR UPDATE
        ON <%=aliases_name %> FOR EACH ROW EXECUTE PROCEDURE <%=trigger_sp_name %>();
    EOS
  end
  
  def down
    execute "DROP TRIGGER <%=trigger_name %> on <%=aliases_name %>;"
    execute "DROP FUNCTION <%=trigger_sp_name(); %>"    
  end
end
