require 'spec_helper'
describe Name do
  let(:term_word) {Faker::Name.first_name}
  let(:term_word2) {Faker::Name.first_name}
  let(:term1) {FactoryGirl.create(:name,:name=>term_word)}
  let(:term2) {FactoryGirl.create(:name,:name=>term_word2)}
    before do
    Name.delete_all
  end
  it 'add a name' do
    expect{Name.add_terms(term_word)}.to change{Name.count}.by(1)
  end
  it 'add many terms' do
    expect{Name.add_terms(term_word,'bar')}.to change{Name.count}.by(2)
  end
  it 'delete a name' do
    term1
    expect{Name.delete_terms(term_word)}.to change{Name.count}.by(-1)
  end
  describe 'update_terms' do
    it 'remove old name' do
      term1
      expect{Name.update_terms([term1.name],[])}.to change{Name.count}.by(-1)
    end
    it 'add new name' do
      expect{Name.update_terms([],[term1.name])}.to change{Name.count}.by(1)
    end
    it 'not change unchanged terms' do
      term1
      expect{Name.update_terms([term1.name],[term1.name])}.to change{Name.count}.by(0)
    end
  end
  describe 'find similar terms' do
    before do
      %W{bird brain brains brawn again brian bran buffalo batch}.each {|t|FactoryGirl.create(:name,:name=>t)}
    end
    it 'should find terms' do
      Name.similar_to('brain').map(&:name).should =~ %W{brain brains bran brawn }
    end
  end
end
