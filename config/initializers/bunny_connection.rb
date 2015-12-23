def connect_to_rabbitmq
  $rabbitmq_connection = Bunny.new(:host => "localhost", :port => 5683, :vhost => "/im", :user => "netclerk", :password => Rails.application.secrets.im_core_password)
  $rabbitmq_connection.start
  $rabbitmq_channel = $rabbitmq_connection.create_channel
  $rabbitmq_exchange = $rabbitmq_channel.topic("IM.Exchange", auto_delete: true)
end

if defined?(PhusionPassenger) # otherwise it breaks rake commands if you put this in an initializer
  PhusionPassenger.on_event(:starting_worker_process) do |forked|
    if forked
       # We’re in a smart spawning mode
       # Now is a good time to connect to RabbitMQ
       connect_to_rabbitmq
    end
  end
else
  connect_to_rabbitmq
end

