require 'spec_helper'

describe Author do
  before do
    SearchTerm.delete_all
  end
  let(:record) {Author.new(:first_name=>'Joe', :last_name=>'Saint John')}
  it 'should calculate_search_terms' do
    record.calculate_search_terms([:first_name, :last_name],true).should == ['joe','saint','john']
  end
  it 'should save search terms' do
    expect{record.save!}.to change{SearchTerm.count}.by(3)
  end
  it 'should delete search terms' do
    record.save!
    expect{record.destroy}.to change{SearchTerm.count}.by(-3)
  end
  it 'should update search terms' do
    record.save!
    record.first_name = 'Mac'
    record.save!
    SearchTerm.where(:term=>'mac').should_not be_empty
    SearchTerm.where(:term=>'joe').should be_empty
  end
  it 'should update search terms for a find' do
    record.save!
    tmp = Author.find(record.id)
    tmp.first_name = 'Mac'
    tmp.save!
    SearchTerm.where(:term=>'mac').should_not be_empty
    SearchTerm.where(:term=>'joe').should be_empty
  end
end
