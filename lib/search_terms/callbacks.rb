module SearchTerms
  module Callbacks
    def calculate_search_terms(fields, break_by_word)
      terms = fields.map {|field| self.send(field.to_sym)}
      terms = terms.map(&:downcase)
      terms = terms.map {|term|term.split(/ +/)}.flatten if break_by_word
      terms
    end
    module ClassMethods
      def search_context(fields, options={})
        context = options[:context] ||= :search_terms
        options[:granularity]||=:broken_by_word
        search_class = options[:context].to_s.singularize.camelize
        var = "@cache_#{options[:context]}"
        cache_proc = "cache_#{options[:context]}".to_sym
        create_proc = "create_#{options[:context]}".to_sym
        update_proc = "update_#{options[:context]}".to_sym
        destroy_proc = "destroy_#{options[:context]}".to_sym
        calculate_proc = "calculate_search_terms(#{fields},#{options[:granularity]==:broken_by_word})"
         eval <<-EOS
        class_eval do
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
ActiveRecord::Base.send :include, SearchTerms::Callbacks
