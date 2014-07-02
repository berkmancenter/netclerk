# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :category do
    factory :social do
      name 'social'
    end
  end
end
