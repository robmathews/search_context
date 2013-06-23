class <%= migration_class_name %> < ActiveRecord::Migration
  def up
    # nop update that hopefully triggers the TRIGGER to update the vector
    execute %Q{UPDATE <%=table_name%> set updated_at = updated_at}
  end
  def down
  end
end
