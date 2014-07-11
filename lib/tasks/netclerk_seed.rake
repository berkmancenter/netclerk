require 'factory_girl_rails'

namespace :netclerk do
  task :seed => :environment do
    seed
  end
end

def seed
  # countries
  usa = FactoryGirl.create :usa

  # categories
  social = FactoryGirl.create :social
  political = FactoryGirl.create :political

  # pages
  twitter = FactoryGirl.create :twitter
  twitter.category = social
  twitter.save

  whitehouse = FactoryGirl.create :whitehouse
  whitehouse.category = political
  whitehouse.save

  # proxies
  proxy_usa = FactoryGirl.create :proxy_usa
  proxy_usa.country = usa
  proxy_usa.save

  # requests
  whitehouse_usa_r01 = FactoryGirl.create :whitehouse_usa_r01
  whitehouse_usa_r01.page = whitehouse
  whitehouse_usa_r01.country = usa
  whitehouse_usa_r01.proxy = proxy_usa
  whitehouse_usa_r01.save

  # statuses
  whitehouse_usa = FactoryGirl.create :whitehouse_usa
  whitehouse_usa.page = whitehouse
  whitehouse_usa.country = usa
  whitehouse_usa.save

end

