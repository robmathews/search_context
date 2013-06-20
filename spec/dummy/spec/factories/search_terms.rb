# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :search_term do
      term { Faker::Name.first_name }
      count 1
    end
end
