FactoryGirl.define do
  factory :proxy do
    factory :proxy_usa do
      ip_and_port '107.182.135.43:3127'
      permanent false
      #country usa
    end

    factory :proxy_chn do
      ip_and_port '116.213.211.130:80'
      permanent false
      #country chn
    end

    factory :proxy_fra do
      ip_and_port '46.105.42.92:3128'
      permanent false
      #country fra
    end

    factory :proxy_irn do
      ip_and_port '109.203.187.248:8080'
      permanent false
      #country irn
    end
  end
end
