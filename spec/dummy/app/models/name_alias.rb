class NameAlias < ActiveRecord::Base
  attr_accessible :original, :substitution
  
  def self.create!(fields)
    [:substitution, :original].each {|k| raise "missing attribute #{k}" unless fields.include?(k) }
    connection.execute("INSERT INTO name_aliases(original, substitution,created_at,updated_at) VALUES (to_tsquery('names_search_config','#{fields[:original]}'),to_tsquery('names_search_config','#{fields[:substitution]}'),localtimestamp, localtimestamp)")
  end
end