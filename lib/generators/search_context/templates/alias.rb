class <%=aliases_class_name %> < ActiveRecord::Base
  attr_accessible :original, :substitution
  
  # not sure how one is supposed to insert tsquery objects, but at least you can insert with this class
  def self.create!(fields)
    [:substitution, :original].each {|k| raise "missing attribute #{k}" unless fields.include?(k) }
    connection.execute("INSERT INTO <%=aliases_name %>(original, substitution,created_at,updated_at) VALUES (to_tsquery('names_search_config','#{fields[:original]}'),to_tsquery('names_search_config','#{fields[:substitution]}'),localtimestamp, localtimestamp)")
  end
end