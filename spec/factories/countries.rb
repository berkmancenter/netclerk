# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :country do
    factory :usa do
      name 'United States'
      iso2 'US'
      iso3 'USA'
    end

    factory :chn do
      name 'China'
      iso2 'CN'
      iso3 'CHN'
    end
  end
end
