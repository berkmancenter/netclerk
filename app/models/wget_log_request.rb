class WgetLogRequest < ActiveRecord::Base
  belongs_to :wget_log

  def ip
    ip_v4
  end
end
