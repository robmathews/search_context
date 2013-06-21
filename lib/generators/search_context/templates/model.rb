require 'search_context'
class <%= class_name %> <ActiveRecord::Base
  include SearchContext::Methods
  attr_accessible :count, :term
  
  # override the search_config if you are using some other search configuration
  def self.search_config
    'english'
  end
  # central place for queries using this search context, if it makes sense to share the search queries amoung multiple duck-typed models.
  # for example, BottleSource, Bottle, Wine all use similar vocabulary and search configuration. and queries
  module Query extend ActiveSupport::Concern
    included do
      scope :similar_to, lambda {|term1|
       where("to_tsquery(?,?) @@ context_search_terms",SearchTerm.search_config, SearchTerm.similar_terms(term1).join(' | '))
      }
    end
  end
end
