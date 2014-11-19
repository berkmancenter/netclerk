class Country < ActiveRecord::Base
  has_many :proxies
  has_many :statuses
end
