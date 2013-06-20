class <%= migration_class_name %> < ActiveRecord::Migration
  def change
    create_table :<%=table_name %> do |t|
      t.string :term
      t.integer :count
      t.timestamps
    end
  end
end
