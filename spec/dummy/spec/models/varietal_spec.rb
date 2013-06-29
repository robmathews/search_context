require 'spec_helper'
require 'transliterate'
describe Varietal do
  
  describe 'fuzzy matching' do
    SYNONYMS = {
     'zinfandel' => [ 'zin','zinfand', 'zinfande','zinfandale'  ,'zinfandel'  ,'zinfandell'  ,'zinfandels'  ,'zinfandil'  ,'zinfandl' ,
     'zinfandwl'  ,'zinfanfel'  ,'zinfanndel'  ,'zinfansekl'  ,'zinfedal',
     'zinfedel'  ,'zinfemdel'  ,'zinfendale'  ,'zinfendel'  ,'zinfendell'  ,'zinfidal'  ,'zinfidel' ,
     'zinfin'  ,'zinfindal'  ,'zinfindale'  ,'zinfinde'  ,'zinfindel'  ,'zinfindell'  ,'zinfinel'  ,
     'zinfinfel'  ,'zinfsndel'  ,'zinfundel'  ,'zingandel'  ,'zinnfandel'  ,'zins'  ,
     'zinvandel'  ,'zinvindal'  ,'zinvindel'  ],
     'cabernet sauvignon' => ['cabernet sauvignon','cabarnet', 'cabernet', 'cabenet', 'sauv', 'cab.', 'cab. sauv', 'cabsav'],
     'cabernet franc' => ['cabernet franc'],
     'chardonnay' =>[
        'chard',
        'charda',
        'chardanay',
        'chardaney',
        'chardannay',
        'chardanney',
        'chardannoy',
        'chardany',
        'charddonany',
        'charddonay',
        'charddonnay',
        'chardenay',
        'chardeney',
        'chardennay',
        'chardeny',
        'chardery',
        'chardina',
        'chardinay',
        'chardine',
        'chardinnay',
        'chardmey',
        'chardnay',
        'chardney',
        'chardnnay',
        'chardnonny',
        'chardnoway',
        'chardo',
        'chardomany',
        'chardomay',
        'chardomey',
        'chardommay',
        'chardomnay',
        'chardomney',
        'chardon',
        'chardona',
        'chardonaany',
        'chardonaey',
        'chardonai',
        'chardonais',
        'chardonal',
        'chardonannay',
        'chardonanny',
        'chardonany',
        'chardonary',
        'chardonau',
        'chardonay',
        'chardonbay',
        'chardone',
        'chardonel',
        'chardonet',
        'chardonette',
        'chardoney',
        'chardonmay',
        'chardonn',
        'chardonna',
        'chardonnai',
        'chardonnais',
        'chardonnal',
        'chardonnary',
        'chardonnat',
        'chardonne',
        'chardonnet',
        'chardonney',
        'chardonniere',
        'chardonnnay',
        'chardonnry',
        'chardonnsy',
        'chardonnu',
        'chardonny',
        'chardonwy',
        'chardony',
        'chardonyeah',
        'chardoonay',
        'chardoonnay',
        'chardouny',
        'chardp',
        'chardpmau',
        'chardpmay',
        'chardpmnay',
        'chardpnay',
        'chardpnays',
        'chardpnmey',
        'chardpnnau',
        'chardpnnay',
        'chards',
        'charduney',
     ]
   }
    SYNONYMS.each_pair do |k,v|
      v.each do |synonym|
        it "maps #{synonym},#{k}" do
          # puts "Varietal.fuzzy_match(#{synonym}).map(&:name)=#{Varietal.fuzzy_match(synonym).map(&:name)}"
          Varietal.fuzzy_match(synonym).map(&:name).map(&:transliterate).map(&:downcase).should be_include(k.transliterate.downcase)
        end
      end
    end
  end
  describe 'word spotting' do
    describe 'basic' do
      let(:varietal) {Varietal.find_by_name('Chardonnay')}
      %W{chardonnay chardonay chardonnnay}.each do |variant|
        it "trigram #{variant}" do
          Varietal.spots_by_trigram("#{variant} red truck with other stuff you know").map(&:name).should =~ [varietal.name]
        end
        it "trigram+tsearch #{variant}" do
          Varietal.spots("#{variant} red truck with other stuff you know").map(&:name).should =~ [varietal.name]
        end
      end
      describe 'multiple words' do
      it 'Cabernet Shiraz' do
        Varietal.spots("2004 Penfolds Bin 60A Cabernet Shiraz").map(&:name).should =~ ['Cabernet Sauvignon', 'Shiraz']
      end
      it 'Merlot-Cabernet' do
        Varietal.spots("2004 Penfolds Bin 60A Merlot-Cabernet").map(&:name).should =~ ['Cabernet Sauvignon', 'Merlot']
      end
    end

      %W{chardonnay}.each do |variant|
        it "tsearch 'red truck #{variant}'"do
          Varietal.spots_by_tsearch("red truck #{variant}").map(&:name).should =~ [varietal.name]
        end
      end
    end
  end
end
