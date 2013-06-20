# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rails/test_help"
require 'faker'
require 'factory_girl_rails'

#grr-can't make this work quickly
Dir.glob("spec/dummy/spec/factories/*.rb").each do |file|
  puts "loading #{file}"
   load "#{file}"
end
Rails.backtrace_cleaner.remove_silencers!

# force include of our gem

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'
end
