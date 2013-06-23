module SearchContext
  module GeneratorHelpers  
    def migrate_if_needed(template,migration)
      unless self.class.migration_exists?(File.dirname(migration),File.basename(migration).gsub('.rb',''))
        migration_template template, migration
      end   
    end
  end
end
Rails::Generators::Base.send :include, SearchContext::GeneratorHelpers