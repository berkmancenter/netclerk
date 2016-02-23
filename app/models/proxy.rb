class Proxy < ActiveRecord::Base
  before_destroy :im_core_down
  after_create :im_core_up

  belongs_to :country

  def ip_and_port
    "#{ip}:#{port}"
  end

  private

  def im_core_down
    im_core_change( {
      event: 'down',
      ip: ip,
      nodeSource: ImCore::USERNAME
    } )
  end

  def im_core_up
    im_core_change( {
      event: 'up',
      ip: ip,
      nodeSource: ImCore::USERNAME,
      countryCode: country.iso2,
      idFromSource: id
    } )
  end

  def im_core_change( message )
    Rails.logger.info "proxy #{message[:event]} country: #{country.iso2}, ip: #{ip}"

    $rabbitmq_exchange.publish( message.to_json, routing_key: ImCore::QUEUE_NAME, content_type: 'application/json' )
  end
end
