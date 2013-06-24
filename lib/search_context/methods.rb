require 'active_support/concern'
module SearchContext
  module Methods extend ActiveSupport::Concern
    included do 
      scope :similar_to, lambda {|name|
        where("similarity(#{table_name}.name::text,?::text) > ? and abs(length(#{table_name}.name) - length(?)) <2",name,similarity_limit,name).
        order("similarity(#{table_name}.name::text,#{sanitize(name)}::text) desc")
      }
    end

    module ClassMethods
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
        similar_to(name).pluck(:name)
      end
    end
  end
end
