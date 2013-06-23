require 'rails/generators'
require 'rails/generators/active_model'
require 'rails/generators/migration'
require 'generators/generator_helpers.rb'

class SearchContextGenerator < Rails::Generators::Base  
  include Rails::Generators::Migration
  source_root File.expand_path('../templates', __FILE__)  
  argument :context, :type => :string, :banner => "<context-name>"  
  
  def self.next_migration_number(path)
      sleep(1) # force a new timestamp
      Time.now.utc.strftime("%Y%m%d%H%M%S")
  end
    
  def create_context
    migrate_if_needed "install_migration.rb", "db/migrate/install_trigram_extension.rb"
    template 'model.rb', "app/models/#{model_file_name}.rb"
    migrate_if_needed "create_model_migration.rb", "db/migrate/create_#{table_name}.rb"
    migrate_if_needed "create_search_config_migration.rb", "db/migrate/add_#{search_config_name}.rb"
    migrate_if_needed "add_context_migration.rb", "db/migrate/add_trigram_index_to_#{context}.rb"
    migrate_if_needed "create_aliases_migration.rb", "db/migrate/create_#{aliases_name}.rb"
  end
  
  protected

  def column_name
    "#{context}_vector"
  end

  def class_name
    model_file_name.camelize
  end

  def model_file_name
    context.underscore.singularize
  end

  def search_config_name
    "#{table_name}_search_config"
  end

  def aliases_name
    "#{table_name.singularize}_aliases"
  end

  def table_name
    context.underscore.pluralize
  end
  def index_name
    "idx_trgm_on_#{table_name}"    
  end
end