require 'spec_helper'
describe SearchTerm do
  let(:term_word) {Faker::Name.first_name}
  let(:term_word2) {Faker::Name.first_name}
  let(:term1) {FactoryGirl.create(:search_term,:term=>term_word)}
  let(:term2) {FactoryGirl.create(:search_term,:term=>term_word2)}
  it 'add a term' do
    expect{SearchTerm.add_terms(term_word)}.to change{SearchTerm.count}.by(1)
  end
  it 'add many terms' do
    expect{SearchTerm.add_terms(term_word,'bar')}.to change{SearchTerm.count}.by(2)
  end
  it 'delete a term' do
    term1
    expect{SearchTerm.delete_terms(term_word)}.to change{SearchTerm.count}.by(-1)
  end
  describe 'update_terms' do
    it 'remove old term' do
      term1
      expect{SearchTerm.update_terms([term1.term],[])}.to change{SearchTerm.count}.by(-1)
    end
    it 'add new term' do
      expect{SearchTerm.update_terms([],[term1.term])}.to change{SearchTerm.count}.by(1)
    end
    it 'not change unchanged terms' do
      term1
      expect{SearchTerm.update_terms([term1.term],[term1.term])}.to change{SearchTerm.count}.by(0)
    end
  end
end
