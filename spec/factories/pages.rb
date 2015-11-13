FactoryGirl.define do
  factory :page do
    url 'http://example.com'
    title 'Example'
    category

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

    factory :playboy do
      url 'http://www.playboy.com'
      title 'Playboy'
      #category pornography
    end

    factory :no_title do
      url 'http://www.no-title.com'
      title nil
      #category social
    end

    factory :berkman do
      url 'http://cyber.law.harvard.edu'
      title 'Berkman Center'
      #category social
    end

    factory :page_with_long_url do
      url "https://example.com/?query=#{SecureRandom.hex(100)}"
    end
  end
end
