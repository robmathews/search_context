require 'active_support/concern'
module SearchContext
  module StringHelpers
    def transliterate
      ActiveSupport::Inflector.transliterate(self)
    end
    def split_pairs(sep=/ |\/|-/, max_length=2)
      words = split(sep)
      words.concat((2..max_length).map {|iii|(0..words.size-iii).map {|index| words.slice(index,iii).join(' ') }}.flatten)
    end
  end

  module Methods extend ActiveSupport::Concern
    included do 
      # attr_accessor :rank, :trigram_rank, :trigram_spot, :tsearch_location, :tsearch_location_rewritten
      
      scope :fuzzy_match_by_trigram, lambda {|name|
        select(column_names.map{|name|"#{table_name}.#{name}"}.concat ["#{ActiveRecord::Base.sanitize(name)} as trigram_spot","similarity(#{table_name}.name::text,#{sanitize(name)}::text) as trigram_rank"]).where("similarity(#{table_name}.name::text,?::text) > ? and abs(length(#{table_name}.name) - length(?)) <2",name,similarity_limit,name).
        order("similarity(#{table_name}.name::text,#{sanitize(name)}::text) desc")
      }
      scope :fuzzy_match_by_tsearch, lambda {|term|
        term_safe = ActiveRecord::Base.sanitize(term.gsub(/\\|\/|-|\?/, ' '))
        rewrite = "plainto_tsquery('#{search_config}',querytree(ts_rewrite(plainto_tsquery('#{alias_search_config}',#{term_safe})
        ,$$select original_tsquery,substitution_tsquery from #{alias_class.table_name} WHERE plainto_tsquery('#{alias_search_config}','#{term}') @>original_tsquery$$)))"
        where("#{rewrite} @@ to_tsvector('#{search_config}',name)").order("ts_rank(to_tsvector('#{search_config}',name),#{rewrite}) desc")
      }
      scope :fuzzy_match, lambda {|term|
        fuzzy_match_by_trigram(term).concat(fuzzy_match_by_tsearch(term)).uniq
      }
      
      # spot the search phrase in the noise, using trigram to look for transposed letters (allows 1=2 errors, depending how close they are), or tsearch (better an phonetic spellings)
      def self.spots_by_trigram(term, max_terms=2)
        result = term.transliterate.split_pairs(/ |\/|-/,max_terms).map {|ttt| fuzzy_match_by_trigram(ttt) }.flatten
        # filter out the weaker matches, allow ties for first place
        max = result.map(&:trigram_rank_f).max 
        result.select {|v| v.trigram_rank_f >= max}
      end
      def self.spots_by_tsearch(term)
        term_safe = ActiveRecord::Base.sanitize(term.gsub(/\\|\/|-|\?/, ' '))
        rewrite_query = "querytree(ts_rewrite(plainto_tsquery('simple',#{term_safe}),$$select original_tsquery,substitution_tsquery from varietal_aliases WHERE plainto_tsquery('simple',#{term_safe}) @>original_tsquery$$))"
        rewrite_tsvector = "to_tsvector('#{search_config}',#{rewrite_query})"
        tsquery = "plainto_tsquery('#{search_config}',name)"
        headline = "ts_headline('#{search_config}',#{term_safe},#{tsquery})"
        headline_rewritten = "ts_headline('#{search_config}',#{rewrite_query},#{tsquery})"
        rank = "ts_rank(#{rewrite_tsvector},#{tsquery},32)"
        result=select(column_names.map{|name|"#{table_name}.#{name}"}.concat ["#{rank} as rank","#{headline} as tsearch_location","#{headline_rewritten} as tsearch_location_rewritten"]).where("#{rewrite_tsvector} @@ #{tsquery}").order(rank)
        # filter out the weaker matches, allow ties for first place
        max = result.map(&:rank_f).max 
        result.select {|v| v.rank_f >= max * 0.50}
      end
      def self.spots(term)
        spots_by_trigram(term).concat(spots_by_tsearch(term)).uniq
      end
    end
    
    def rank_f
      rank.to_f
    end

    def trigram_rank_f
      trigram_rank.to_f
    end
    # for the last spots by tsearch command. returns the original word it matched against
    def spot
      if respond_to?(:trigram_spot)
       trigram_spot
      else
       tsearch_spot
      end
    end
    
    def tsearch_spot
      return $1 if tsearch_location.scan(/<b>(\w.*)<\/b>/)
      return $1 if tsearch_location_rewritten.scan(/<b>(\w.*)<\/b>/)
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
        0.420 # don't ask
      end
      def similar_terms(name)
        fuzzy_match(name).map(&:name)
      end
    end
  end
end
String.send :include, SearchContext::StringHelpers
