require 'rails/generators'
require 'rails/generators/active_model'
require 'rails/generators/migration'

class SearchContextGenerator < Rails::Generators::Base  
  include Rails::Generators::Migration
  source_root File.expand_path('../templates', __FILE__)  
  argument :context, :type => :string, :default => "search_terms"  
  
  def self.next_migration_number(path)
      sleep(1) # force a new timestamp
      Time.now.utc.strftime("%Y%m%d%H%M%S")
  end
    
  def create_context
    unless self.class.migration_exists?('db/migrate','install_trigram_extension')
      migration_template "install_migration.rb", "db/migrate/install_trigram_extension.rb"
    end
    unless self.class.migration_exists?('db/migrate',"create_#{table_name}")
      template 'model.rb', "app/models/#{model_name}.rb"
      migration_template "create_model_migration.rb", "db/migrate/create_#{table_name}.rb"
      migration_template "add_context_migration.rb", "db/migrate/add_trigram_index_to_#{context}.rb"
    end
  end
  
  protected
  def class_name
    model_name.camelize
  end
  def model_name
    context.underscore.singularize
  end
  def table_name
    context.underscore.pluralize
  end
  def index_name
    "idx_trgm_on_#{table_name}"    
  end
end