require 'factory_girl_rails'

namespace :netclerk do
  task :seed => :environment do
    seed
  end
end

def seed
  # usa
  usa = FactoryGirl.create :usa

  # social
  social = FactoryGirl.create :social

  # twitter
  twitter = FactoryGirl.create :twitter
  twitter.category = social
  twitter.save

  # proxies
  proxy_usa = FactoryGirl.create :proxy_usa
  proxy_usa.country = usa
  proxy_usa.save
end

