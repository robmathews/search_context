class AddSearchTermsVectorToAuthors < ActiveRecord::Migration
  def change
    add_column :authors, :search_terms_vector, :tsvector
  end
end
