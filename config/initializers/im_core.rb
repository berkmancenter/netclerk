module ImCore
  HOST = ENV['IM_CORE_HOST']
  PORT = ENV['IM_CORE_PORT']
  VHOST = ENV['IM_CORE_VHOST']
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

end

if defined?(PhusionPassenger) # otherwise it breaks rake commands if you put this in an initializer
  PhusionPassenger.on_event(:starting_worker_process) do |forked|
    if forked
       # We’re in a smart spawning mode
       # Now is a good time to connect to RabbitMQ
       ImCore.connect_to_rabbitmq
    end
  end
else
  ImCore.connect_to_rabbitmq
end

