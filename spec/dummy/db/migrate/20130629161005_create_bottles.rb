class CreateBottles < ActiveRecord::Migration
  def change
    create_table :bottles do |t|
      t.string :name
      t.string :varietal

      t.timestamps
    end
  end
end
