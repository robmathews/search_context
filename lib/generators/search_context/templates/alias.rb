class <%=aliases_class_name %> < ActiveRecord::Base
  # database trigger maintains *_tsquery versions
  attr_accessible :original, :substitution
end