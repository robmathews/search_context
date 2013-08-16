require File.expand_path('../../migration_helper', __FILE__)
include MigrationHelper

class <%= migration_class_name %> < ActiveRecord::Migration
  def up
    install_extension('pg_trgm')
  end

  def down
    uninstall_extension('pg_trgm')
  end
end
