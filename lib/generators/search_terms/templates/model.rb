class <%= class_name %> <ActiveRecord::Base
  include SearchTerms::Methods
  attr_accessible :count, :term
end
