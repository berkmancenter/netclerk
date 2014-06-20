# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :country do
    factory :usa do
      name 'United States'
      iso3 'USA'
    end
  end
end
