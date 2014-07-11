FactoryGirl.define do
  factory :proxy do
    factory :proxy_usa do
      ip_and_port '199.241.190.252:3128'
      permanent false
      #country usa
    end
  end
end
