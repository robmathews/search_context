require File.expand_path('../../migration_helper', __FILE__)
include MigrationHelper

class InstallTrigramExtension < ActiveRecord::Migration
  def up
    install_extension('pg_trgm', 'similarity')
  end

  def down
    uninstall_extension('pg_trgm')
  end
end
