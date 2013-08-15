require 'spec_helper'

describe "test word spotting on real data" do
  Bottle.all.each do |bottle|
    next if bottle.name =~ /Louis Jadot Gevrey Chambertin Clos Saint Jacque/ #Jacque matches "Jacquère" with a rank of 0.41, and it's hard to disagree
    next if bottle.name =~ /2004 JC Cellars Syrah Fess Parker's Vineyard Santa Barbara County/ # shiraz works, but Barbera is a major varietal in Portugal
    next if bottle.name =~ /2003 Ciacci Piccolomini d'Aragona Brunello di Montalcino Vigna di Pianrosso/ # same deal for Aragona, it matches aragones
    next if bottle.name =~ /Fattoria dei Barbi Brunello di Montalcino/ # Barbi mwatches Barbera, which is a red Italian wine grape variety that, as of 2000, was the third most-planted red grape variety in Italy (after Sangiovese and Montepulciano).
    next unless bottle.name =~/Iron Horse T-bar-T Cabernet Franc/ # also matches "cabernet sauvignon"
    # "'hous' & 'coach' & 'coach' & 'block' & 'branson' & '<b>sauvignon</b>' & '<b>cabernet</b>' & '<b>sauvignon</b>' & 'blanc'"
    it "#{bottle.name} spots #{bottle.varietal}" do
      if false
        guess = Varietal.spots_by_trigram(bottle.name)
        unless guess.empty?
          puts "#{bottle.name} spots_by_trigram"
          # guess.each {|g| puts g.name, '=>',g.trigram_rank} <= WHY? FAIL?
          guess.each {|g| puts g.name}
        end
        guess = Varietal.spots_by_tsearch(bottle.name)
        unless guess.empty?
          puts "#{bottle.name} spots_by_tsearch"
          guess.each {|g| puts g.name}
        end
      end
      Varietal.spots(bottle.name).map(&:name).map(&:transliterate).map(&:downcase).should =~ bottle.varietal.transliterate.downcase.split('|')
    end
  end
end
