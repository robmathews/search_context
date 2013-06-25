class CreateVarietalAliases < ActiveRecord::Migration
  def change
    # populate this table with your query rewrite rules
    create_table :varietal_aliases do |t| t.timestamps end
    add_column :varietal_aliases, :original_tsquery, :tsquery
    add_column :varietal_aliases, :substitution_tsquery, :tsquery
    add_column :varietal_aliases, :original, :string
    add_column :varietal_aliases, :substitution, :string
  end
end
