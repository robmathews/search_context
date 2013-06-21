class <%= migration_class_name %> < ActiveRecord::Migration
  def change
    add_column :<%=table_name %>, :<%=column_name %>, :tsvector
  end
end
