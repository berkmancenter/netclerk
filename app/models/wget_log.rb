class WgetLog < ActiveRecord::Base
  has_many :wget_log_requests
end
