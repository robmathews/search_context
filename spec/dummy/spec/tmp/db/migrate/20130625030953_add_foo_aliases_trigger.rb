class AddFooAliasesTrigger < ActiveRecord::Migration
  def up
    execute <<-EOS
    CREATE OR REPLACE FUNCTION sp_update_foo_aliases() RETURNS trigger AS $$
    begin
      new.original_tsquery = to_tsquery(foos_search_config, coalesce(new.original,''))
      new.substitution_tsquery = to_tsquery(foos_search_config, coalesce(new.substitution,''))
      return new;
    end
    $$ LANGUAGE plpgsql;
    EOS
    execute <<-EOS
    DROP TRIGGER IF EXISTS trigger_update_foo_aliases ON foos;
    CREATE TRIGGER trigger_update_foo_aliases BEFORE INSERT OR UPDATE
        ON foos FOR EACH ROW EXECUTE PROCEDURE sp_update_foo_aliases();
    EOS
  end
  def down
    execute "DROP TRIGGER trigger_update_foo_aliases"
    execute "DROP FUNCTION sp_update_foo_aliases"
    
  end
end
