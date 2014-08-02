FactoryGirl.define do
  factory :page do
    factory :twitter do
      url 'https://twitter.com'
      title 'Twitter'
      #category social
    end

    factory :whitehouse do
      url 'http://www.whitehouse.gov'
      title 'The White House'
      #category political
    end

    factory :no_title do
      url 'http://www.no-title.com'
      #category social
    end
  end
end
