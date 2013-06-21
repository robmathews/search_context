class Author < ActiveRecord::Base
  attr_accessible :first_name, :last_name
  search_context [:first_name, :last_name], :context=>:names
end
