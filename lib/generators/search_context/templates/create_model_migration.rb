class <%= migration_class_name %> < ActiveRecord::Migration
  def change
    create_table :<%=table_name %> do |t|
      t.string :name
      <%if include_count -%>
        t.integer :count
      <%end%>
      t.timestamps
    end
  end
end
