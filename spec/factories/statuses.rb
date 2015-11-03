FactoryGirl.define do
  factory :status do
    value 3
    delta 0
    created_at '2014-11-19'
    country
    page

    factory :twitter_usa do
      #country usa
      #page twitter
      value 3
      delta 0
      created_at '2014-07-11'
    end

    factory :whitehouse_usa do
      #country usa
      #page whitehouse
      value 3
      delta 0
      created_at '2014-07-11'
    end

    factory :whitehouse_usa_yesterday do
      #country usa
      #page whitehouse
      value 3
      delta 0
      created_at '2014-07-10'
    end

    factory :twitter_chn do
      #country chn
      #page twitter
      value 0
      delta 0
      created_at '2014-07-11'
    end

    factory :whitehouse_chn do
      #country chn
      #page whitehouse
      value 0
      delta -1
      created_at '2014-07-11'
    end

    factory :whitehouse_chn_yesterday do
      #country chn
      #page whitehouse
      value 1
      delta 0
      created_at '2014-07-10'
    end

    factory :twitter_fra do
      #country fra
      #page twitter
      value 3
      delta 0
      created_at '2014-07-11'
    end

    factory :whitehouse_fra do
      #country fra
      #page whitehouse
      value 2
      delta 0
      created_at '2014-07-11'
    end

    factory :whitehouse_fra_yesterday do
      #country fra
      #page whitehouse
      value 2
      delta 0
      created_at '2014-07-10'
    end

    factory :twitter_irn do
      #country irn
      #page twitter
      value 1
      delta 1
      created_at '2014-07-11'
    end

    factory :twitter_irn_yesterday do
      #country irn
      #page twitter
      value 0
      delta 0
      created_at '2014-07-10'
    end

    factory :whitehouse_irn do
      #country irn
      #page whitehouse
      value 1
      delta 0
      created_at '2014-07-11'
    end

    factory :playboy_irn do
      #country irn
      #page playboy
      value 0
      delta 0
      created_at '2014-07-11'
    end

    factory :no_title_irn do
      #country irn
      #page no_title
      value 3
      delta 0
      created_at '2014-07-11'
    end

    factory :whitehouse_bra_yesterday do
      #country bra
      #page whitehouse
      value 3
      delta 0
      created_at '2014-07-10'
    end
  end
end
