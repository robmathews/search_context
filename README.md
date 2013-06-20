search_terms
============

Maintain a trigram index of valid search terms associated with a model

# In brief

## To install: 

Generate a context (default is in the table search_terms, but you have have multiple contexts if needed.)

```bash
rails g search_terms
```

This will create the search_terms model, install the pg_trigram extension, and create trigram index on the model.

Or run it again with a context name if you need to create multiple search contexts.
```bash
rails g search_terms some_other_search_terms
```

## In your model, 

```rails
class Author < ActiveRecord::Base
  maintains_search_terms(:columns=>[:first_name, :last_name], :context=>:search_terms, :granularity=>:broken_by_word)
end
```
context is the name of the table to use, multiple models can share the same table
fields are the database columns to use. Non-database columns are not supported
granularity is either "broken_by_word" or "complete". This means that we'll either index by each word in the result, or keep them complete. Default is broken_by_word, which usually makes the most sense. Complete might be more useful for book titles ...

## To use

Now you can query the search_terms table for similar words to any given word, for example this would return an active relation consisting of similar first names to 'Charlie'.

    Author.mispellings_for('Charlie')
    
Under the covers, this is doing the following:

    Author.join("join search_terms.term % first_name").where('search_terms.term % ?','Charlie')

## Initial rake test to prepopulate all the data

    rake search_terms:populate_context[some_other_search_terms]
  
Which clears the table and then populates each row from the given fields.
