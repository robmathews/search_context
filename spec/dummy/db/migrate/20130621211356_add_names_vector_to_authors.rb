class AddNamesVectorToAuthors < ActiveRecord::Migration
  def change
    add_column :authors, :names_vector, :tsvector
  end
end
