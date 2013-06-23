require 'rails/generators'
require 'rails/generators/active_model'
require 'rails/generators/migration'
require 'generators/generator_helpers.rb'
class EnableTsearchGenerator < Rails::Generators::Base  
  include Rails::Generators::Migration
  source_root File.expand_path('../templates', __FILE__)  
  argument :table_name, :type => :string
  argument :context, :type=>:string
  argument :columns, :type => :array, :banner => "col1 col2 col3 ..."
   
  
  def self.next_migration_number(path)
      sleep(1) # force a new timestamp
      Time.now.utc.strftime("%Y%m%d%H%M%S")
  end
    
  def create_context
    migrate_if_needed("add_column_migration.rb","db/migrate/add_#{column_name}_to_#{table_name}.rb")
    migrate_if_needed("add_trigger_migration.rb", "db/migrate/add_#{context}_trigger_to_#{table_name}.rb")
    migrate_if_needed("add_tsearch_index_migration.rb", "db/migrate/add_#{context}_tsearch_index_to_#{table_name}.rb")
  end
  
  protected
  def column_name
    "#{context}_vector"
  end
  def search_config_name
     "#{context}_search_config"
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