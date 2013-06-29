require 'spec_helper'

describe "test word spotting on real data" do
  Bottle.all.each do |bottle|
    # plan to toss out the bottles w/o a varietal in the name
    next unless bottle.varietal.empty?
    it "#{bottle.name} spots #{bottle.varietal}" do
      guess = Varietal.spots(bottle.name)
      unless guess.empty?
        puts "#{bottle.name} spots"
        guess.each {|g| puts g.name}
      else
        # puts "#{bottle.name} FAILS"
      end
      # Varietal.spots(bottle.name) == bottle.varietal
    end
  end
end
