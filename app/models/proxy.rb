class Proxy < ActiveRecord::Base
  belongs_to :country
  def ip
    parts.first
  end
  
  def port
    parts.last.to_i
  end

  private 
  def parts
    ip_and_port.split(':')
  end
end
