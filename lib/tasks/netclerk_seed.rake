require 'factory_girl_rails'

namespace :netclerk do
  task :seed => :environment do
    seed
  end
end

def seed
  # usa
  usa = FactoryGirl.create :usa
end

