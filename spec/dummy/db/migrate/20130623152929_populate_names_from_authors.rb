class PopulateNamesFromAuthors < ActiveRecord::Migration
  def up
      execute(%Q{drop table if exists term_vectors})
      execute <<-EOS
       -- DELETE from #<Binding:0x007fe566200618>;
       INSERT into names(name, count, created_at, updated_at)
       SELECT word, ndoc as count, now() as created_at, now() as updated_at
       FROM ts_stat(
       'SELECT to_tsvector(''simple'',
                    coalesce(first_name,'''')
                                  ||  '' '' ||coalesce(last_name,'''')
                                  )
       FROM authors') 
      EOS
  end
  def down
    execute %Q{DELETE from #<Binding:0x007fe566200618>}
  end
end

