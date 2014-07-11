class Request < ActiveRecord::Base
  belongs_to :page
  belongs_to :country
  belongs_to :proxy
end
