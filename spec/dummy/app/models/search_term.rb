require 'search_terms'
class SearchTerm <ActiveRecord::Base
  include SearchTerms::Methods
  #TODO - move into SearchTerms somehow
  scope :similar_to, lambda {|term1|
    where("#{table_name}.term::text % ?::text",term1)
  }
  def self.similar_terms(term1)
    similar_to(term1).pluck(&:term)
  end
  
  attr_accessible :count, :term
end
