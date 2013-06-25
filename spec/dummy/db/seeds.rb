require 'csv'    
Varietal.delete_all
VarietalAlias.delete_all
if Varietal.count == 0
  CSV.foreach('db/static/varietals.csv', :headers => true) do |row|
    Varietal.create!(row.to_hash)
  end
  CSV.foreach('db/static/varietal_aliases.csv', :headers => true) do |row|
    VarietalAlias.create!(row.to_hash)
  end
end