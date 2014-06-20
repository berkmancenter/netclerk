# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :country do
    name "MyString"
    iso3 "MyString"
    local_dns "MyString"
  end
end
