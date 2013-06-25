require 'spec_helper'
require 'transliterate'
describe Varietal do
  
  describe 'should find similar varietal' do
    SYNONYMS = {
     'zinfandel' => [ 'zin','zinfand', 'zinfande','zinfandale'  ,'zinfandel'  ,'zinfandell'  ,'zinfandels'  ,'zinfandil'  ,'zinfandl' ,
     'zinfandwl'  ,'zinfanf'  ,'zinfanfel'  ,'zinfanndel'  ,'zinfans'  ,'zinfansekl'  ,'zinfedal',
     'zinfedel'  ,'zinfemdel'  ,'zinfendale'  ,'zinfendel'  ,'zinfendell'  ,'zinfidal'  ,'zinfidel' ,
     'zinfin'  ,'zinfindal'  ,'zinfindale'  ,'zinfinde'  ,'zinfindel'  ,'zinfindell'  ,'zinfinel'  ,
     'zinfinfel'  ,'zinfinger'  ,'zinfsndel'  ,'zinfundel'  ,'zingandel'  ,'zinnfandel'  ,'zins'  ,
     'zinvandel'  ,'zinvindal'  ,'zinvindel'  ],
     'cabernet sauvignon' => ['cabernet sauvignon', 'cab. sauvignon','cabarnet', 'cabenet','cabernet', 'sauv', 'cab.', 'cab. sauv', 'cab sav', 'cabsav', 'cab3', 'sauvignon'],
     'chardonnay' =>[
        'chandon',
        'chard',
        'chard-on-yeah',
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
        'chardoe',
        'chardom',
        'chardomany',
        'chardomay',
        'chardomey',
        'chardomm',
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
        it "#{synonym} maps to #{k}" do
          puts "Varietal.similar_to(#{synonym}).pluck(:name)=#{Varietal.similar_to(synonym).pluck(:name)}"
          Varietal.similar_to(synonym).pluck(:name).map(&:transliterate).map(&:downcase).should be_include(k.transliterate.downcase)
        end
      end
    end
  end
end
