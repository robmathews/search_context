# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :author do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
  end
end
