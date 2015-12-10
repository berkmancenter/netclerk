# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence :name do |n|
    "Category #{n}"
  end

  factory :category do
    name

    factory :social do
      name 'social'
    end

    factory :political do
      name 'political'
    end

    factory :pornography do
      name 'pornography'
    end
  end
end
