class CreateSearchTerms < ActiveRecord::Migration
  def change
    create_table :search_terms do |t|
      t.string :term
      t.integer :count
      t.timestamps
    end
  end
end
