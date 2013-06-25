class AddVarietalAliasesTrigger < ActiveRecord::Migration
  def up
    execute <<-EOS
    CREATE OR REPLACE FUNCTION sp_update_varietal_aliases() RETURNS trigger AS $$
    begin
      new.original_tsquery = plainto_tsquery('varietals_search_config', coalesce(new.original,''));
      new.substitution_tsquery = plainto_tsquery('varietals_search_config', coalesce(new.substitution,''));
      return new;
    end
    $$ LANGUAGE plpgsql;
    EOS
    execute <<-EOS
    DROP TRIGGER IF EXISTS trigger_update_varietal_aliases ON varietals;
    CREATE TRIGGER trigger_update_varietal_aliases BEFORE INSERT OR UPDATE
        ON varietal_aliases FOR EACH ROW EXECUTE PROCEDURE sp_update_varietal_aliases();
    EOS
  end
  def down
    execute "DROP TRIGGER trigger_update_varietal_aliases ON varietal_aliases;"
    execute "DROP FUNCTION sp_update_varietal_aliases();"
    
  end
end
