require 'spec_helper'

describe "test word spotting on real data" do
  Bottle.all.each do |bottle|
    # next unless bottle.name =~ /2004 Branson Coach Coach House Block Cabernet Sauvignon/
    # "'hous' & 'coach' & 'coach' & 'block' & 'branson' & '<b>sauvignon</b>' & '<b>cabernet</b>' & '<b>sauvignon</b>' & 'blanc'"
    it "#{bottle.name} spots #{bottle.varietal}" do
      guess = Varietal.spots_by_trigram(bottle.name)
      unless guess.empty?
        puts "#{bottle.name} spots_by_trigram"
        guess.each {|g| puts g.name}
        # debugger
      end
      guess = Varietal.spots_by_tsearch(bottle.name)
      unless guess.empty?
        puts "#{bottle.name} spots_by_tsearch"
        guess.each {|g| puts g.name}
        # debugger
      end
      Varietal.spots_by_tsearch(bottle.name).map(&:name).map(&:transliterate).map(&:downcase).should =~ bottle.varietal.transliterate.downcase.split('|')
    end
  end
end
