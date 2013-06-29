class <%= migration_class_name %> < ActiveRecord::Migration
  def up
      execute <<-EOS
       -- DELETE from <%=search_context %>;
       INSERT into <%=search_context %>(name, count,created_at, updated_at)
       SELECT word, ndoc as count, now() as created_at, now() as updated_at
       FROM ts_stat(
       'SELECT to_tsvector(''simple'',
       <% sep='';columns.each do |column| -%>
             <%=sep%>coalesce(<%=column %>,'''')
             <%sep=" || '' '' ||" -%>
       <% end -%>
       ) FROM <%=table_name %>
       ')
      EOS
  end
  def down
    execute %Q{DELETE from <%=search_context %>}
  end
end

