module SearchTerms
  module Methods
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
    end

    def self.included(base)
        base.extend(ClassMethods)
    end
  end
end
