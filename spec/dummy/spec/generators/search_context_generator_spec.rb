require 'spec_helper'
require "generator_spec/test_case"
require 'generators/search_context/search_context_generator'
describe SearchContextGenerator do
  include GeneratorSpec::TestCase
  destination File.expand_path("../../tmp", __FILE__)
  arguments %w(foos)

  before do
    prepare_destination
  end

  it "creates a search_context with a count" do
    run_generator %w(foos --dynamic)
    assert_file "app/models/foo.rb", /:count/
  end
  it "creates a search_context with w/o count" do
    run_generator %w(foos --skip-dynamic)
    assert_file "app/models/foo.rb", /attr_accessible  :name$/
  end

  after do
    assert_file "app/models/foo.rb", /class Foo/
    assert_file "app/models/foo_alias.rb", /class FooAlias/
    assert_migration "db/migrate/install_trigram_extension.rb"
    assert_migration "db/migrate/create_foos.rb"
    assert_migration "db/migrate/add_trigram_index_to_foos.rb"
    assert_migration "db/migrate/add_foos_search_config.rb"
    assert_migration "db/migrate/create_foo_aliases.rb"
    assert_migration "db/migrate/add_foo_aliases_trigger.rb"
  end
end
