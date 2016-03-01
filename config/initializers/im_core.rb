module ImCore
  HOST = ENV['IM_CORE_HOST']
  PORT = ENV['IM_CORE_PORT']
  VHOST = ENV['IM_CORE_VHOST']
  PENDING_QUEUE_NAME = ENV['IM_CORE_PENDING_QUEUE_NAME']
  QUEUE_NAME = ENV['IM_CORE_QUEUE_NAME']
  USERNAME = ENV['IM_CORE_USERNAME']
  PASSWORD = ENV['IM_CORE_PASSWORD']

  def self.connect_to_rabbitmq
    begin
      $rabbitmq_connection = Bunny.new(:host => HOST, :port => PORT, :vhost => VHOST, :user => USERNAME, :password => PASSWORD)
      $rabbitmq_connection.start
      $rabbitmq_channel = $rabbitmq_connection.create_channel
      $rabbitmq_exchange = $rabbitmq_channel.topic("IM.Exchange", auto_delete: true)
    rescue
      Rails.logger.info 'could not connect to RabbitMQ'
    end
  end

  def self.start_pending_listener
    Thread.new {
      Rails.logger.info "creating pending queue: #{ImCore::PENDING_QUEUE_NAME}"
      queue = $rabbitmq_channel.queue( ImCore::PENDING_QUEUE_NAME, auto_delete: false, durable: true )
      Rails.logger.info "created queue.name: #{queue.name}"
      queue.bind( $rabbitmq_exchange, routing_key: queue.name )

      consumer = queue.subscribe( block: true ) { | delivery_info, metadata, payload |
        Rails.logger.info "Received #{payload}"
        message = JSON.parse(payload)

        country = Country.find_by_iso2 message[ :countryCode ]
        Proxy.create( ip: message[ :ip ], port: message[ :port ], permanent: false, country: country )

      }
    }
  end

end

if defined?(PhusionPassenger) # otherwise it breaks rake commands if you put this in an initializer
  PhusionPassenger.on_event(:starting_worker_process) do |forked|
    if forked
      # We’re in a smart spawning mode
      # Now is a good time to connect to RabbitMQ
      ImCore.connect_to_rabbitmq
      ImCore.start_pending_listener
    end
  end
else
  ImCore.connect_to_rabbitmq
  if Rails.const_defined?( 'Server' )
    # Local development/WEBrick
    ImCore.start_pending_listener
  end
end

