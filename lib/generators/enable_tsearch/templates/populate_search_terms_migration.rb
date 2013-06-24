class <%= migration_class_name %> < ActiveRecord::Migration
  def up
      execute(%Q{drop table if exists term_vectors})
      execute <<-EOS
       -- DELETE from <%=context %>;
       INSERT into <%=context %>(name, count,created_at, updated_at)
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
    execute %Q{DELETE from <%=context %>}
  end
end

