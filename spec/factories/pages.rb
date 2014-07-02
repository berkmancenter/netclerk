# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :page do
    factory :twitter do
      url 'https://twitter.com'
      title 'Twitter'
      #category social
    end
  end
end
