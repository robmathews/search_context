require 'search_context'
class Varietal <ActiveRecord::Base
  include SearchContext::Methods
  attr_accessible  :name
  
  # override the search_config if you are using some other search configuration
  def self.search_config
    "varietals_search_config"
  end
  # central place for queries using this search context, if it makes sense to share the search queries amoung multiple duck-typed models.
  # for example, BottleSource, Bottle, Wine all use similar vocabulary and search configuration. and queries
  module Query extend ActiveSupport::Concern
    included do
      # this example demostrates synonyms and stop words implemented via the aliases table, which you have to figure out
      # how to populate on your own
      scope :fuzzy_match, lambda {|term1|
       similar_terms= term1.split(/ +/).inject([]) do |acc, name| [name].concat(Varietal.similar_terms(name).uniq) end.flatten.join(' | ')
       where("ts_rewrite(to_tsquery(?,?),'select original_tsquery,substitution_tsquery from varietal_aliases WHERE to_tsquery('?','?') @>original_tsquery') @@ varietals_vector",
           Varietal.search_config,similar_terms,
           Varietal.search_config, similar_terms)
      }
    end
  end
end
