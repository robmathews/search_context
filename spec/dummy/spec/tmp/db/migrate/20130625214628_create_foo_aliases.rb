class CreateFooAliases < ActiveRecord::Migration
  def change
    # populate this table with your query rewrite rules
    create_table :foo_aliases do |t| t.timestamps end
    add_column :foo_aliases, :original_tsquery, :tsquery
    add_column :foo_aliases, :substitution_tsquery, :tsquery
    add_column :foo_aliases, :original, :string
    add_column :foo_aliases, :substitution, :string
  end
end
