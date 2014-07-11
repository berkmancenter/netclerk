class Status < ActiveRecord::Base
  belongs_to :page
  belongs_to :country
end
