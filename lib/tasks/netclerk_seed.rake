require 'csv'
require 'factory_girl_rails'

namespace :netclerk do
  namespace :seed do
    desc 'Seed test database'
    task :test => :environment do
      seed_test
    end

    desc 'Load all countries'
    task :countries => :environment do
      seed_countries
    end

    desc 'Load ONI URLs'
    task :oni => :environment do
      seed_oni
    end
  end
end

def seed_test
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

  no_title = FactoryGirl.create :no_title
  no_title.category = social
  no_title.save

  # proxies
  proxy_usa = FactoryGirl.create :proxy_usa
  proxy_usa.country = usa
  proxy_usa.save

  #proxy_chn = FactoryGirl.create :proxy_chn
  #proxy_chn.country = chn
  #proxy_chn.save

  #proxy_fra = FactoryGirl.create :proxy_fra
  #proxy_fra.country = fra
  #proxy_fra.save

  #proxy_irn = FactoryGirl.create :proxy_irn
  #proxy_irn.country = irn
  #proxy_irn.save

  # requests
  whitehouse_usa_r01 = FactoryGirl.create :whitehouse_usa_r01
  whitehouse_usa_r01.page = whitehouse
  whitehouse_usa_r01.country = usa
  whitehouse_usa_r01.proxy = proxy_usa
  whitehouse_usa_r01.save

  whitehouse_usa_r02 = FactoryGirl.create :whitehouse_usa_r02
  whitehouse_usa_r02.page = whitehouse
  whitehouse_usa_r02.country = usa
  whitehouse_usa_r02.proxy = proxy_usa
  whitehouse_usa_r02.save

  # statuses
  create_status :twitter_usa, usa, twitter
  create_status :whitehouse_usa_yesterday, usa, whitehouse
  create_status :whitehouse_usa, usa, whitehouse

  create_status :twitter_chn, chn, twitter
  create_status :whitehouse_chn_yesterday, chn, whitehouse
  create_status :whitehouse_chn, chn, whitehouse

  create_status :twitter_fra, fra, twitter
  create_status :whitehouse_fra_yesterday, fra, whitehouse
  create_status :whitehouse_fra, fra, whitehouse

  create_status :twitter_irn, irn, twitter
  create_status :whitehouse_irn, irn, whitehouse
end

def create_status( factory, country, page )
  status = FactoryGirl.create factory
  status.country = country
  status.page = page
  status.save
end

def seed_countries
  CSV.open(Rails.root.join('db', 'data_files', 'countryInfo.txt'), {:headers => true, :col_sep => "\t"}).each do |line|
    country = Country.create(
      name: line['Country'],
      iso3: line['ISO3'],
      iso2: line['ISO']
    )
  end
end

def seed_oni
  ent = Dir.entries Rails.root.join('db', 'data_files', 'oni' )

  ent.each { |f| 
    if f.present? && !File.directory?(f)
      puts "Loading #{f}"
      CSV.open( Rails.root.join( 'db', 'data_files', 'oni', f ), { :headers => true } ).each do |line|
        url = line['url']
        if Page.find_by( url: url ).nil?
          page = Page.new( url: url)
          page.save
        end
      end
    end
  }
end

