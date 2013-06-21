search_context
============

Maintain a trigram index of valid search terms associated with a model, plus other useful tidbits from the postgres tsearch+trigram world.


## To install: 

Generate a context (default is in the table search_terms, but you have have multiple contexts if needed.)

```bash
rails g search_context
```

This will create the search_terms model and migrations to install the pg_trigram extension (if needed), create the model table, and create trigram index on the model. The index type is 'gin', if you need a 'gist' index, edit the migration before running it.

Or run it again with a context name if you need to create multiple search contexts.
```bash
rails g search_context some_other_search_terms
```

## In your model 

```rails
class Author < ActiveRecord::Base
  search_context([:first_name, :last_name], :context=>:search_terms, :granularity=>:broken_by_word)
end
```
context is the name of the table to use, multiple models can share the same table
fields are the database columns to use. Non-database columns are not supported
granularity is either "broken_by_word" or "complete". This means that we'll either index by each word in the result, or keep them complete. Default is broken_by_word, which usually makes the most sense. Complete might be more useful for book titles ...

## To use

Now you can query the search_terms table for similar words to any given word, for example this would return an active relation consisting of similar first names to 'Charlie'.

    Author.search_terms_mispellings_for(:first_name,'Charlie')
    
Under the covers, this is doing the following:

    Author.join("join search_terms.term % first_name").where('search_terms.term % ?','Charlie')
    
## Integration with tsearch

This scope can be integrated with the tsearch query like this: 
    Author.where("to_tsquery(?,?) @@ context_search_terms",SearchTerm.search_config, SearchTerm.similar_to_as_tsvector('Charlie'))
    
This is only an example of what you can do, really you'll be wanting to author something tsearch specific pretty quickly using features like weighting. Therefore this gems approach is only to sketch an outline and provide useful functions and tools for you to extend.

## Generation of scopes in a module for each Context

Since this gem supports reusing the context in several different models, it automatically includes module from the context called 'SearchTerms::Query' which is a place where you can author the scopes that you want to share between the different models.


## Initial rake test to prepopulate all the data

    rake search_terms:populate_context[search_terms,author]
  
Which clears the table and then populates each row from the given fields. On large databases, this task can take some time to complete, hence it is offered in two forms, as raw sql (faster). Of course, that will not work if your generation of search terms requires a join to some other table to get some of the terms. In that case, just use the task as a guide to creating your own.
 