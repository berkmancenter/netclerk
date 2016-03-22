require 'net/http'

module ImCore
  HOST = ENV['IM_CORE_HOST']
  PORT = ENV['IM_CORE_PORT']
  VHOST = ENV['IM_CORE_VHOST']
  PENDING_QUEUE_NAME = ENV['IM_CORE_PENDING_QUEUE_NAME']
  JOBS_ROUTE = ENV['IM_CORE_JOBS_ROUTE']
  JOBS_QUEUE_NAME = "#{ENV['IM_CORE_JOBS_ROUTE']}.watcher"
  JOBS_ROUTING_KEY = "#{ENV['IM_CORE_JOBS_ROUTE']}.*.*.*.*"
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
      Rails.logger.error 'could not connect to RabbitMQ'
    end
  end

  def self.start_listeners
    # start pending listener
    pending_queue = $rabbitmq_channel.queue( ImCore::PENDING_QUEUE_NAME, auto_delete: false, durable: true )
    pending_queue.bind( $rabbitmq_exchange, routing_key: pending_queue.name )

    pending_queue.subscribe { | delivery_info, metadata, payload |
      Rails.logger.info "[pending] routing_key: #{pending_queue.name}, payload: #{payload}"

      message = JSON.parse(payload)

      case message[ 'event' ]
      when 'up'
        country = Country.find_by_iso2 message[ 'countryCode' ]
        Proxy.create( ip: message[ 'ip' ], port: message[ 'port' ], permanent: false, country: country )
      when 'down'
        id = message[ 'id' ]
        if Proxy.where( id: id ).empty?
          Rails.logger.info "[pending] down message for missing proxy id: #{id}"
        else
          Proxy.find( id ).destroy
        end
      when 'ping'
        # send up messages for all existing proxies
        Proxy.all.each( &:im_core_up )
      else
        Rails.logger.info "[pending] unknown message event #{message[ 'event' ]}"
      end
    }

    # start jobs listener
    jobs_queue = $rabbitmq_channel.queue( ImCore::JOBS_QUEUE_NAME, auto_delete: false, durable: true )
    jobs_queue.bind( $rabbitmq_exchange, routing_key: ImCore::JOBS_ROUTING_KEY )

    jobs_queue.subscribe { | delivery_info, metadata, payload |
      # sample message:
      # {"id":23,"url":"http://cyber.law.harvard.edu","postTo":"http://localhost:3000/laapi/requests"}
      Rails.logger.info "[jobs] routing_key: #{delivery_info[ :routing_key ]}, payload: #{payload}"

      message = JSON.parse payload

      # proxy_ip will be part of payload later
      routing_key = delivery_info[ :routing_key ]
      proxy_ip = routing_key[ ImCore::JOBS_ROUTE.length+1..-1]

      proxy = Proxy.find_by ip: proxy_ip
      im_job = ImJob.from_message message

      if proxy.present? && im_job.valid?
        proxy.perform im_job
      else
        Rails.logger.info "[jobs] could not find proxy with IP #{proxy_ip}" unless proxy.present?
        Rails.logger.info "[jobs] could not find proxy with IP #{proxy_ip}" unless im_job.valid?
      end
    }

    # send up messages for all existing proxies
    Proxy.all.each( &:im_core_up )
  end

  def self.send_message( routing_key, message )
    Rails.logger.info "[im_core] routing_key: #{routing_key}, message: #{message}"

    $rabbitmq_exchange.publish( message.to_json, routing_key: routing_key, content_type: 'application/json' )
  end
end

unless NetClerk.maintenance? || Rails.const_defined?( 'Console' )
  if defined?(PhusionPassenger) # otherwise it breaks rake commands if you put this in an initializer
    PhusionPassenger.on_event(:starting_worker_process) do |forked|
      if forked
        # We’re in a smart spawning mode
        # Now is a good time to connect to RabbitMQ
        ImCore.connect_to_rabbitmq
        ImCore.start_listeners
      end
    end
  else
    ImCore.connect_to_rabbitmq
    if Rails.const_defined?( 'Server' )
      # Local development/WEBrick
      ImCore.start_listeners
    end
  end
end
