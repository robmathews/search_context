class AddNamesSearchConfig < ActiveRecord::Migration
  def up
     # install unaccent if it isn't installed'
     if select_value(%Q{select extname from pg_extension where extname = 'unaccent'}).nil?
       execute "CREATE EXTENSION unaccent"
     end
     # create a new search configuration by copying an existing one. For my purposes, I wanted to use the french dictionary and
     # remove all the accent characters. You could equally use the english dictionary as your base, or create your own.
     # this is only intended to show you the basic command.
     
     execute %Q{CREATE TEXT SEARCH CONFIGURATION names_search_config ( COPY = french );}
     execute %Q{ALTER TEXT SEARCH CONFIGURATION names_search_config
             ALTER MAPPING FOR hword, hword_part, word
             WITH unaccent, french_stem;}
  end

  def down
    execute "DROP TEXT SEARCH CONFIGURATION names_search_config"
  end
end
