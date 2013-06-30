#!ruby19
# encoding: utf-8
require 'spec_helper'
describe SearchContext::StringHelpers do
  describe 'split_pairs' do
    it "one word" do
      "w0rd".split_pairs.should =~ ["w0rd"]
    end
    it "3 word" do
      "bar food sucks".split_pairs.should =~ ["bar", "food", "sucks", "bar food", "food sucks"]
    end
    it "hypens" do
      "bar-food sucks".split_pairs.should =~ ["bar", "food", "sucks", "bar food", "food sucks"]
    end
  end
  it 'transliterate' do
    "Bogdanuša".transliterate.should == 'Bogdanusa'
  end
end