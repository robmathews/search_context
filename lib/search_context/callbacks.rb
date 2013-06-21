module SearchContext
  module Callbacks
    def calculate_search_terms_helper(fields, break_by_word)
      terms = fields.map {|field| self.send(field.to_sym)}
      terms = terms.map(&:downcase)
      terms = terms.map {|term|term.split(/ +/)}.flatten if break_by_word
      terms
    end
    module ClassMethods
      def search_context(fields, options={})
        context = options[:context] ||= :search_terms
        options[:granularity]||=:broken_by_word
        search_class = context.to_s.singularize.camelize
        var = "@cache_#{context}"
        cache_proc = "cache_#{context}".to_sym
        create_proc = "create_#{context}".to_sym
        update_proc = "update_#{context}".to_sym
        destroy_proc = "destroy_#{context}".to_sym
        calculate_proc = "calculate_#{context}"
         eval <<-EOS
        class_eval do
          include #{search_class}::Query
          def #{cache_proc}
            #{var} = #{calculate_proc}
            true
          end
          def #{create_proc}
            #{search_class}.add_terms(*#{calculate_proc})
            true
          end
          def #{update_proc}
            #{search_class}.update_terms(#{var}||[],#{calculate_proc})
            true
          end
          def #{destroy_proc}
            #{search_class}.delete_terms(*#{calculate_proc})
            true
          end
          def #{context}_mispellings_for(column,term)
            join("join #{context}.term % ?",column).where('#{context}.term % ?',term)
          end
          
          # override this method if you want to calculate your search terms in some other way, like perhaps joining to a parent record and getting some addition search terms from there
          def #{calculate_proc}
            calculate_search_terms_helper(#{fields},#{options[:granularity]==:broken_by_word})
          end
        end
        EOS

        after_find cache_proc
        after_save cache_proc
        after_create create_proc
        after_update update_proc
        after_destroy destroy_proc
      end
    end
    def self.included(base)
        base.extend(ClassMethods)
    end
  end
end
ActiveRecord::Base.send :include, SearchContext::Callbacks
