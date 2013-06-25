class <%= migration_class_name %> < ActiveRecord::Migration
  def change
    create_table :<%=table_name %> do |t|
      t.string :name
      <%if options.dynamic? -%>
        t.integer :count
      <%end%>
      t.timestamps
    end
  end
end
