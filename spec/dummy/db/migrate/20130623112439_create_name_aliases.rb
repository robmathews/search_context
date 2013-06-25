class CreateNameAliases < ActiveRecord::Migration
  def change
    # populate this table with your query rewrite rules
    create_table :name_aliases do |t| t.timestamps end
      add_column :name_aliases, :original_tsquery, :tsquery
      add_column :name_aliases, :substitution_tsquery, :tsquery
      add_column :name_aliases, :original, :string
      add_column :name_aliases, :substitution, :string
  end
end
