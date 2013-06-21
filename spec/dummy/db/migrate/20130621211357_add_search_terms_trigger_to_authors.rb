class AddSearchTermsTriggerToAuthors < ActiveRecord::Migration
  def up
    execute <<-EOS
    -- feel free to customize this function if you want to join to columns from another table, for example
    CREATE OR REPLACE FUNCTION sp_update_search_terms_vector() RETURNS trigger AS $$
    begin
      new.search_terms_vector :=
                  setweight(to_tsvector('pg_catalog.english', coalesce(new.first_name,'')), 'A')
                              || setweight(to_tsvector('pg_catalog.english', coalesce(new.last_name,'')), 'A')
                  ;
      return new;
    end
    $$ LANGUAGE plpgsql;
    EOS
    execute <<-EOS
    DROP TRIGGER IF EXISTS update_search_terms_vector  ON authors;
    CREATE TRIGGER update_search_terms_vector BEFORE INSERT OR UPDATE
        ON authors FOR EACH ROW EXECUTE PROCEDURE sp_update_search_terms_vector();
    EOS
  end
  def down
    execute "DROP TRIGGER update_search_terms_vector"
    execute "DROP FUNCTION sp_update_search_terms_vector"
    
  end
end
