require 'spec_helper'
require "generator_spec/test_case"
require 'generators/enable_tsearch/enable_tsearch_generator'
describe EnableTsearchGenerator do
  include GeneratorSpec::TestCase
  destination File.expand_path("../../tmp", __FILE__)


# !!! you were here. 
# some tests are: 
# - create a search context with a count
# w/o a count
# - generate a model to go with
# - rails generate enable_tsearch <table> <context> <col1> <col2> ...
# - test with a list of fields
# - test with a :symbol
# 
  before do
    prepare_destination
    FileUtils.mkdir_p("#{destination_root}/app/models")
    copy('spec/dummy/app/models/foo.rb',"#{destination_root}/app/models/foo.rb")
  end

  it "creates a search_context with a count" do
    run_generator %w(foos names field1 field2)
    assert_file "#{destination_root}/app/models/foo.rb", /^ +search_context/
  end
  after do
    assert_migration "db/migrate/add_names_vector_to_foos.rb"
    assert_migration "db/migrate/add_names_trigger_to_foos.rb"
    assert_migration "db/migrate/add_names_tsearch_index_to_foos.rb"
    assert_migration "db/migrate/populate_names_vector_on_foos.rb"
    assert_migration "db/migrate/populate_names_from_foos.rb"
  end
end
