require File.expand_path('../../migration_helper', __FILE__)
include MigrationHelper

class <%= migration_class_name %> < ActiveRecord::Migration
  def up
     # install unaccent if it isn't installed'
     install_extension('unaccent')

     # create a new search configuration by copying an existing one. For my purposes, I wanted to use the french dictionary and
     # remove all the accent characters. You could equally use the english dictionary as your base, or create your own.
     # this is only intended to show you the basic command.
     
     execute %Q{CREATE TEXT SEARCH CONFIGURATION <%=search_config_name%> ( COPY = pg_catalog.french );}
    # From the docs, you typically don't want these mappings for simple searches of names and names of things, so I show you how to 
    # drop them here
    #   Parsing documents into tokens. It is useful to identify various classes of tokens, e.g., numbers, words, complex words,
    #   email addresses, so that they can be processed differently.
    #   In principle token classes depend on the specific application, but for most purposes it 
    #   is adequate to use a predefined set of classes. PostgreSQL uses a parser to perform this step.
    #    A standard parser is provided, and custom parsers can be created for specific needs.
     execute %{ALTER TEXT SEARCH CONFIGURATION <%=search_config_name%>
            DROP MAPPING FOR email, file, float, host, int, sfloat, uint, url, url_path, version}
    # remove all the accent characters. 
     execute %Q{ALTER TEXT SEARCH CONFIGURATION <%=search_config_name%>
             ALTER MAPPING FOR hword, hword_part, word
             WITH unaccent, french_stem;}
    
    # create a variant of the simple dictionary that ignores accents
    execute %Q{CREATE TEXT SEARCH CONFIGURATION <%=alias_search_config_name%> ( COPY = pg_catalog.simple );}
    execute %{ALTER TEXT SEARCH CONFIGURATION <%=alias_search_config_name%>
           DROP MAPPING FOR email, file, float, host, int, sfloat, uint, url, url_path, version}
    execute %Q{ALTER TEXT SEARCH CONFIGURATION <%=alias_search_config_name%>
            ALTER MAPPING FOR hword, hword_part, word
            WITH unaccent, simple;}
  end

  def down
    execute "DROP TEXT SEARCH CONFIGURATION <%=search_config_name%>"
    execute "DROP TEXT SEARCH CONFIGURATION <%=alias_search_config_name%>"
  end
end
