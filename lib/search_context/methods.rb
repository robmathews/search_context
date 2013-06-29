require 'active_support/concern'
module SearchContext
  module Methods extend ActiveSupport::Concern
    included do 
      scope :fuzzy_match_by_trigram, lambda {|name|
        where("similarity(#{table_name}.name::text,?::text) > ? and abs(length(#{table_name}.name) - length(?)) <2",name,similarity_limit,name).
        order("similarity(#{table_name}.name::text,#{sanitize(name)}::text) desc")
      }
      scope :fuzzy_match_by_tsearch, lambda {|term|
        rewrite = "ts_rewrite(plainto_tsquery('#{search_config}','#{term}')
        ,$$select original_tsquery,substitution_tsquery from #{alias_class.table_name} WHERE plainto_tsquery('#{search_config}','#{term}') @>original_tsquery$$) "
        where("#{rewrite} @@ to_tsvector('#{search_config}',name)").order("ts_rank(to_tsvector('#{search_config}',name),#{rewrite}) desc")
      }
      scope :fuzzy_match, lambda {|term|
        fuzzy_match_by_trigram(term).concat(fuzzy_match_by_tsearch(term)).uniq
      }
      # spot the search phrase in the noise
      scope :spots_by_trigram, lambda {|term|
        # normalized score is more than 70%, which is 1 - 0.30
        where("similarity(?,name) * length(?)/length(name) > ?",term,term,1 - similarity_limit)
      }
      scope :spots_by_tsearch, lambda {|term|
        term_safe = ActiveRecord::Base.sanitize(term.gsub(/\/|-|\?/, ' '))
        rewrite_query = "to_tsvector('#{search_config}',querytree(ts_rewrite(plainto_tsquery('#{search_config}',#{term_safe}),$$select original_tsquery,substitution_tsquery from varietal_aliases WHERE plainto_tsquery('#{search_config}',#{term_safe}) @>original_tsquery$$)))"
        where("#{rewrite_query} @@ plainto_tsquery('#{search_config}',name)").order("ts_rank(#{rewrite_query},plainto_tsquery('#{search_config}',name)) desc")
      }
      scope :spots, lambda {|term|
        spots_by_trigram(term).concat(spots_by_tsearch(term)).uniq
      }
    end

    module ClassMethods
      def alias_class
        Module.const_get("#{name}Alias".to_sym)
      end
      # here we add the function methods for search terms
      def update_terms(old_terms, new_terms)
        delete_terms(*(old_terms - new_terms))
        add_terms(*(new_terms - old_terms))
      end
      def delete_terms(*terms)
        where(:name=>terms).update_all("count=count-1")
        where(:name=>terms,:count=>0).delete_all
      end
      def add_terms(*terms)
        where(:name=>terms).update_all("count=count+1")
        new_terms = terms - self.where(:name=>terms).pluck(:name)
        new_terms.each {|name| self.create!(:count=>1,:name=>name)}
      end
      # default definition of similarity, you can override this in the class if needed
      def similarity_limit
        0.27
      end
      def similar_terms(name)
        fuzzy_match(name).map(&:name)
      end
    end
  end
end
