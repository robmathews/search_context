require File.expand_path('../../migration_helper', __FILE__)
include MigrationHelper

class AddNamesSearchConfig < ActiveRecord::Migration
  def up
     # install unaccent if it isn't installed'
     install_extension('unaccent')

     # create a new search configuration by copying an existing one. For my purposes, I wanted to use the french dictionary and
     # remove all the accent characters. You could equally use the english dictionary as your base, or create your own.
     # this is only intended to show you the basic command.
     
     execute %Q{CREATE TEXT SEARCH CONFIGURATION names_search_config ( COPY = french );}
     execute %Q{ALTER TEXT SEARCH CONFIGURATION names_search_config
             ALTER MAPPING FOR hword, hword_part, word
             WITH unaccent, french_stem;}

      execute %Q{CREATE TEXT SEARCH CONFIGURATION names_alias_search_config ( COPY = pg_catalog.simple );}
      execute %{ALTER TEXT SEARCH CONFIGURATION names_alias_search_config
             DROP MAPPING FOR email, file, float, host, int, sfloat, uint, url, url_path, version}
     # remove all the accent characters. 
      execute %Q{ALTER TEXT SEARCH CONFIGURATION names_alias_search_config
              ALTER MAPPING FOR hword, hword_part, word
              WITH unaccent, simple;}
  end

  def down
    execute "DROP TEXT SEARCH CONFIGURATION names_search_config"
    execute "DROP TEXT SEARCH CONFIGURATION names_alias_search_config"
  end
end
