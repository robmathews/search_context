require 'search_terms'
class SearchTerm <ActiveRecord::Base
  include SearchTerms::Methods
  
  attr_accessible :count, :term
end
