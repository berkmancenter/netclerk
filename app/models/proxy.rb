class Proxy < ActiveRecord::Base
  before_destroy :im_core_down
  after_create :im_core_up

  belongs_to :country

  def ip_and_port
    "#{ip}:#{port}"
  end

  def queue_name
    "#{ImCore::QUEUE_NAME}.#{ip}"
  end

  def job_queue
    "#{queue_name}.jobs"
  end

  def job_status_queue
    "#{job_queue}.status"
  end

  private

  def im_core_down
    im_core_change( {
      event: 'down',
      ip: ip,
      nodeSource: ImCore::USERNAME
    } )

    end_listener
  end

  def im_core_up
    im_core_change( {
      event: 'up',
      ip: ip,
      nodeSource: ImCore::USERNAME,
      countryCode: country.iso2,
      idFromSource: id
    } )

    start_listener
  end

  def start_listener
    @queue = $rabbitmq_channel.queue( job_queue, auto_delete: false, durable: true )
    @queue.bind( $rabbitmq_exchange, routing_key: @queue.name )

    @listener_thread = Thread.new {
      @consumer = @queue.subscribe( block: true ) { | delivery_info, metadata, payload |
        Rails.logger.info "Received #{payload}"
        message = JSON.parse(payload)

  #      form_data = {
  #        'probe_url' => message['url'],
  #        'postback_url' => message['postTo'],
  #        'data_types' => [
  #          'headers', 'timeline', 'errors', 'screenshot', 'resources',
  #          'dns_detail', 'http_detail', 'pcap'
  #        ],
  #        'useragent' => Rails.configuration.x.dyn.user_agents.sample,
  #        'collectors': { node.id_from_source => {} }
  #      }
  #
  #      puts 'Sending job'
  #      puts form_data
  #
  #      response = nil
  #      in_session(SEND_JOB_URL) do |http|
  #        request = Net::HTTP::Post.new(SEND_JOB_URL)
  #        request.content_type = 'application/json'
  #        request.body = JSON.dump(form_data)
  #        response = http.request(request)
  #      end
  #      puts response.inspect
  #      puts response.body
  #
  #      start_message = {
  #        event: 'start',
  #        requestId: message['requestId'],
  #        responseId: message['responseId']
  #      }
  #      $rabbitmq_exchange.publish(start_message.to_json,
  #                                 routing_key: node.job_status_queue,
  #                                 content_type: 'application/json')
  #
      }
    }
  end

  def end_listener
    @consumer.cancel
    @listener_thread.kill
    @queue.purge
    @queue.unbind
    @queue.delete
  end

  def im_core_change( message )
    Rails.logger.debug "proxy #{message[:event]} country: #{country.iso2}, ip: #{ip}"

    $rabbitmq_exchange.publish( message.to_json, routing_key: ImCore::QUEUE_NAME, content_type: 'application/json' )
  end
end
