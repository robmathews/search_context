require 'spec_helper'
describe Name do
  let(:term_word) {Faker::Name.first_name}
  let(:term_word2) {Faker::Name.first_name}
  let(:term1) {FactoryGirl.create(:name,:term=>term_word)}
  let(:term2) {FactoryGirl.create(:name,:term=>term_word2)}
    before do
    Name.delete_all
  end
  it 'add a term' do
    expect{Name.add_terms(term_word)}.to change{Name.count}.by(1)
  end
  it 'add many terms' do
    expect{Name.add_terms(term_word,'bar')}.to change{Name.count}.by(2)
  end
  it 'delete a term' do
    term1
    expect{Name.delete_terms(term_word)}.to change{Name.count}.by(-1)
  end
  describe 'update_terms' do
    it 'remove old term' do
      term1
      expect{Name.update_terms([term1.term],[])}.to change{Name.count}.by(-1)
    end
    it 'add new term' do
      expect{Name.update_terms([],[term1.term])}.to change{Name.count}.by(1)
    end
    it 'not change unchanged terms' do
      term1
      expect{Name.update_terms([term1.term],[term1.term])}.to change{Name.count}.by(0)
    end
  end
  describe 'find similar terms' do
    before do
      %W{bird brain brains brawn again brian bran buffalo batch}.each {|t|FactoryGirl.create(:name,:term=>t)}
    end
    it 'should find terms' do
      Name.similar_to('brain').pluck(:term).should == %W{brain brains bran brawn }
    end
  end
end
