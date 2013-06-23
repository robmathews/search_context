require 'active_support/concern'
module SearchContext
  module Methods extend ActiveSupport::Concern
    included do 
      scope :similar_to, lambda {|term|
        where("similarity(#{table_name}.term::text,?::text) > ? and abs(length(#{table_name}.term) - length(?)) <2",term,similarity_limit,term)
      }
    end

    module ClassMethods
      # here we add the function methods for search terms
      def update_terms(old_terms, new_terms)
        delete_terms(*(old_terms - new_terms))
        add_terms(*(new_terms - old_terms))
      end
      def delete_terms(*terms)
        where(:term=>terms).update_all("count=count-1")
        where(:term=>terms,:count=>0).delete_all
      end
      def add_terms(*terms)
        where(:term=>terms).update_all("count=count+1")
        new_terms = terms - self.where(:term=>terms).pluck(:term)
        new_terms.each {|term| self.create!(:count=>1,:term=>term)}
      end
      # default definition of similarity, you can override this in the class if needed
      def similarity_limit
        0.27
      end
      def similar_terms(term)
        similar_to(term).pluck(:term)
      end
    end
  end
end
