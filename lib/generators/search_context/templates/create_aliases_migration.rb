class <%= migration_class_name %> < ActiveRecord::Migration
  def change
    # populate this table with your query rewrite rules
    create_table :<%=aliases_name %> do |t| t.timestamps end
    add_column :<%=aliases_name %>, :original, :tsquery
    add_column :<%=aliases_name %>, :substitution, :tsquery
  end
end
