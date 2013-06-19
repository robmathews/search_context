class SearchTermsGenerator < Rails::Generators::Base  
  source_root File.expand_path('../templates', __FILE__)  
  argument :context, :type => :string, :default => "search_terms"  
  
  def create_context
    generate('model',"#{context} count:integer term:string")
    migration_template "install.rb", "db/migrate/install_trigram_extension.rb"
    migration_template "migration.rb", "db/migrate/add_trigram_index_to_#{context}.rb"
  end
  
  protected:
  def table_name
    context.table_name
  end
  def index_name
    "idx_trgm_on_#{}"
    context.table_name
  end
end