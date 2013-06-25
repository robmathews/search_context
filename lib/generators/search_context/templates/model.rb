require 'search_context'
class <%= class_name %> <ActiveRecord::Base
  include SearchContext::Methods
  attr_accessible <%if options.dynamic? -%>
    :count,<%end%> :name
  
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
      scope :similar_to, lambda {|term1|
       similar_terms= term1.split(/ +/).inject([]) do |acc, name| [name].concat(<%= class_name %>.similar_terms(name).uniq) end.flatten.join(' | ')
       where("ts_rewrite(to_tsquery(?,?),'select original_tsquery,substitution_tsquery from <%=aliases_name%> WHERE to_tsquery('?','?') @>original_tsquery') @@ <%=column_name%>",
           <%= class_name %>.search_config,similar_terms,
           <%= class_name %>.search_config, similar_terms)
      }
    end
  end
end
