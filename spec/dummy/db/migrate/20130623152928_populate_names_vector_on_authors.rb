class PopulateNamesVectorOnAuthors < ActiveRecord::Migration
  def up
    # nop update that hopefully triggers the TRIGGER to update the vector
    execute %Q{UPDATE authors set updated_at = updated_at}
  end
  def down
  end
end
