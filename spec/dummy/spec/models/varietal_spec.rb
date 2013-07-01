require 'spec_helper'
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
        'chardinay',
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
        it "fuzzy_match #{synonym},#{k}" do
          # puts "Varietal.fuzzy_match(#{synonym}).map(&:name)=#{Varietal.fuzzy_match(synonym).map(&:name)}"
          Varietal.fuzzy_match(synonym).map(&:name).map(&:transliterate).map(&:downcase).should be_include(k.transliterate.downcase)
        end
      end
    end
  end
  # this is just the list of the what similarity algorithm finds similar with a threshold >.29. Allowing words with 2 nearby errors requires a threshold more like 0.23
  SYNONYMS_NO_REWRITES = {
   'zinfandel' => [ 'zinfande','zinfandale'  ,'zinfandel'  ,'zinfandell'  ,'zinfandels'  ,'zinfandil'  ,'zinfandl' ,
   'zinfandwl'  ,'zinfanfel'  ,'zinfanndel'  ,
   'zinfemdel'   ,'zinfendel'  ,'zinfidel' ,
   'zinfindel'  ,
   'zinfsndel'  ,'zinfundel'  ,'zingandel'  ,'zinnfandel'  ,
   'zinvandel'  ,'zinvindel'  ],
   'cabernet sauvignon' => ['cabernet sauvignon'],
   'cabernet franc' => ['cabernet franc']
  }
  SYNONYMS_NO_REWRITES.each_pair do |k,v|
    v.each do |synonym|
      it "fuzzy_match_by_trigram #{k},#{synonym}" do
        Varietal.fuzzy_match_by_trigram(synonym).should_not be_empty
        Varietal.fuzzy_match_by_trigram(synonym).map(&:trigram_spot).map(&:transliterate).map(&:downcase).should be_include(synonym.transliterate.downcase)
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
      it 'no substrings' do
        Varietal.spots_by_trigram("2004 Penfolds Bin 60A Cabernet Sauvignon").map(&:name).should =~ ['Cabernet Sauvignon']
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

      describe 'remembers original spot' do
        it 'trigram case' do
          Varietal.spots_by_trigram("2004 Penfolds Bin 60A Merlot").first.spot == 'merlot'
        end
        it 'tsearch case' do
          Varietal.spots_by_tsearch("2004 Penfolds Bin 60A Merlot").first.spot == 'merlot'
        end
        it 'either case/random order' do
          Varietal.spots("2004 Penfolds Bin 60A Merlot").first.spot == 'merlot'
        end
      end
    end
  end
end
