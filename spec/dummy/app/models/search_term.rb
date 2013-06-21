require 'search_context'
class SearchTerm <ActiveRecord::Base
  attr_accessible :count, :term
  include SearchContext::Methods

  def self.search_config
    'english'
  end

  module Query extend ActiveSupport::Concern
    included do
      scope :similar_to, lambda {|term1|
       where("to_tsquery(?,?) @@ context_search_terms",SearchTerm.search_config, SearchTerm.similar_terms(term1).join(' | '))
      }
    end
  end
end
