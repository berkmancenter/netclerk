class Proxy < ActiveRecord::Base
  belongs_to :country

  def ip_and_port
    "#{ip}:#{port}"
  end
end
