class AddNameAliasesTrigger < ActiveRecord::Migration
  def up
    execute <<-EOS
    CREATE OR REPLACE FUNCTION sp_update_name_aliases() RETURNS trigger AS $$
    begin
      new.original_tsquery = plainto_tsquery('names_alias_search_config', coalesce(new.original,''));
      new.substitution_tsquery = plainto_tsquery('names_alias_search_config', coalesce(new.substitution,''));
      return new;
    end
    $$ LANGUAGE plpgsql;
    EOS
    execute <<-EOS
    DROP TRIGGER IF EXISTS trigger_update_name_aliases ON name_aliases;
    CREATE TRIGGER trigger_update_name_aliases BEFORE INSERT OR UPDATE
        ON name_aliases FOR EACH ROW EXECUTE PROCEDURE sp_update_name_aliases();
    EOS
  end
  
  def down
    execute "DROP TRIGGER trigger_update_name_aliases on name_aliases;"
    execute "DROP FUNCTION sp_update_name_aliases"    
  end
end
