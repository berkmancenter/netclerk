require 'factory_girl_rails'

namespace :netclerk do
  task :seed => :environment do
    seed
  end
end

def seed
  # countries
  usa = FactoryGirl.create :usa
  chn = FactoryGirl.create :chn
  fra = FactoryGirl.create :fra
  irn = FactoryGirl.create :irn

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
  create_status :whitehouse_usa_yesterday, usa, whitehouse
  create_status :whitehouse_usa, usa, whitehouse

  create_status :whitehouse_chn_yesterday, chn, whitehouse
  create_status :whitehouse_chn, chn, whitehouse

  create_status :whitehouse_fra_yesterday, fra, whitehouse
  create_status :whitehouse_fra, fra, whitehouse

  create_status :whitehouse_irn, irn, whitehouse
end

def create_status( factory, country, page )
  status = FactoryGirl.create factory
  status.country = country
  status.page = page
  status.save
end
