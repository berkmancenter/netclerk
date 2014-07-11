FactoryGirl.define do
  factory :status do
    factory :whitehouse_usa do
      #country usa
      #page whitehouse
      value 0
      delta 0
      created_at '2014-07-11'
    end

    factory :whitehouse_usa_yesterday do
      #country usa
      #page whitehouse
      value 0
      delta 0
      created_at '2014-07-10'
    end

    factory :whitehouse_chn do
      #country chn
      #page whitehouse
      value 3
      delta 1
      created_at '2014-07-11'
    end

    factory :whitehouse_chn_yesterday do
      #country chn
      #page whitehouse
      value 2
      delta 0
      created_at '2014-07-10'
    end
  end
end
