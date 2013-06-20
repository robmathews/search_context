class CreateSearchTerms < ActiveRecord::Migration
  def change
    create_table :search_terms do |t|
      t.integer :count
      t.string :term

      t.timestamps
    end
  end
end
