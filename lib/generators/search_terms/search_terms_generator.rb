require 'rails/generators'
require 'rails/generators/migration'

class SearchTermsGenerator < Rails::Generators::Base  
  include Rails::Generators::Migration
  source_root File.expand_path('../templates', __FILE__)  
  argument :context, :type => :string, :default => "search_terms"  
  argument :attributes, :type => :array, :default => [], :banner => "field:type field:type"
  
  def self.next_migration_number(path)
      sleep(1) # force a new timestamp
      Time.now.utc.strftime("%Y%m%d%H%M%S")
  end
    
  def create_context
    generate('model',"#{model_name} count:integer term:string #{extra_columns}")
    unless self.class.migration_exists?('db/migrate','install_trigram_extension')
      migration_template "install_migration.rb", "db/migrate/install_trigram_extension.rb"
    end
    migration_template "add_context_migration.rb", "db/migrate/add_trigram_index_to_#{context}.rb"
  end
  
  protected
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