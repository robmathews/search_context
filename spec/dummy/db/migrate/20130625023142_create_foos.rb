class CreateFoos < ActiveRecord::Migration
  def change
    create_table :foos do |t|
      t.string :field1
      t.string :field2

      t.timestamps
    end
  end
end
