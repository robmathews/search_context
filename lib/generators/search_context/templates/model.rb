require 'search_context'
class <%= class_name %> <ActiveRecord::Base
  include SearchContext::Methods
  attr_accessible :count, :term
  
  # override the search_config if you are using some other search configuration
  def self.search_config
    "<%= search_config_name %>"
  end
  # central place for queries using this search context, if it makes sense to share the search queries amoung multiple duck-typed models.
  # for example, BottleSource, Bottle, Wine all use similar vocabulary and search configuration. and queries
  module Query extend ActiveSupport::Concern
    included do
      # this example demostrates synonyms and stop words implemented via the aliases table, which you have to figure out
      # how to populate on your own
      ts_rewrite('a & b'::tsquery,
                        'SELECT t,s FROM aliases WHERE ''a & b''::tsquery @> t')
      scope :similar_to, lambda {|term1|
       similar_terms = <%= class_name %>.similar_terms(term1).join(' | ')
       where("ts_rewrite(to_tsquery(?,?),'select original,substitution from <%=aliases_name%> WHERE to_tsquery('?','?') @>original') @@ <%=column_name%>",
           <%= class_name %>.search_config,similar_terms,
           <%= class_name %>.search_config, similar_terms)
      }
    end
  end
end
