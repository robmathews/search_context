require 'rails/generators'
require 'rails/generators/active_model'
require 'rails/generators/migration'
require 'generators/generator_helpers.rb'
class EnableTsearchGenerator < Rails::Generators::Base  
  include Rails::Generators::Migration
  source_root File.expand_path('../templates', __FILE__)  
  argument :table_name, :type => :string
  argument :search_context, :type=>:string
  argument :columns, :type => :array, :banner => "col1 col2 col3 ..."
   
  
  def self.next_migration_number(path)
      sleep(1) # force a new timestamp
      Time.now.utc.strftime("%Y%m%d%H%M%S")
  end
    
  def create_context
    tmp = "  search_context [:#{columns.join(',:')}], :search_context=>:#{search_context}\n" unless columns.empty?
    tmp = "  search_context :a_method_that_returns_the_search_terms, :search_context=>:#{search_context}\n" if columns.empty?
    inject_into_file "app/models/#{table_name.singularize}.rb", tmp , :after => /class #{table_name.singularize.camelize} < .*\n/
    migrate_if_needed("add_column_migration.rb","db/migrate/add_#{column_name}_to_#{table_name}.rb")
    migrate_if_needed("add_trigger_migration.rb", "db/migrate/add_#{search_context}_trigger_to_#{table_name}.rb")
    migrate_if_needed("add_tsearch_index_migration.rb", "db/migrate/add_#{search_context}_tsearch_index_to_#{table_name}.rb")
    migrate_if_needed("populate_vector_migration.rb", "db/migrate/populate_#{column_name}_on_#{table_name}.rb")
    migrate_if_needed("populate_search_terms_migration.rb", "db/migrate/populate_#{search_context}_from_#{table_name}.rb")
  end
  
  protected
  def column_name
    "#{search_context}_vector"
  end
  def search_config_name
     "#{search_context}_search_config"
   end
  def index_name
    "idx_#{column_name}_on_#{table_name}"    
  end
  def trigger_name
    "update_#{column_name}"    
  end
  def trigger_sp_name
    "sp_update_#{column_name}"    
  end
end