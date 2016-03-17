class Proxy < ActiveRecord::Base
  before_destroy :im_core_down
  after_create :im_core_up

  belongs_to :country

  def ip_and_port
    "#{ip}:#{port}"
  end

  def job_queue
    "im.jobs.#{ImCore::USERNAME}.#{ip}"
  end

  def job_status_queue
    "#{job_queue}.status"
  end

  def im_core_down
    ImCore.send_message( ImCore::QUEUE_NAME, {
      event: 'down',
      ip: ip,
      source: ImCore::USERNAME
    } )

    end_listener
  end

  def im_core_up
    ImCore.send_message( ImCore::QUEUE_NAME, {
      event: 'up',
      ip: ip,
      source: ImCore::USERNAME,
      location: {
        countryCode: country.iso2
      },
      idFromSource: id
    } )

    start_listener
  end

  private

  def start_listener
    if @listener_thread.nil?
      @listener_thread = Thread.new {
        job_q = $rabbitmq_channel.queue( job_queue, auto_delete: false, durable: true )
        job_q.bind( $rabbitmq_exchange, routing_key: job_q.name )

        job_status_q = $rabbitmq_channel.queue( job_status_queue, auto_delete: false, durable: true )
        job_status_q.bind( $rabbitmq_exchange, routing_key: job_status_q.name )

      # TODO: only need one listener for all of NetClerk, check out routing_keys in dyn
      # queue_name can be anything, routing_key is the messages we want to listen on
        consumer = job_q.subscribe( block: true ) { | delivery_info, metadata, payload |
          Rails.logger.info "queue: #{job_q.name}, payload: #{payload}"

          message = JSON.parse payload

          ImCore.send_message( job_status_q.name, {
            event: 'start',
          id: message[ 'requestId' ]
          } )

          sleep 5

        # postTo IM Core, don't need IM Core id
        }
      }
    end
  end

  def end_listener
    @listener_thread.kill if @listener_thread.present?

    job_q = $rabbitmq_channel.queue( job_queue, auto_delete: false, durable: true )
    job_q.delete

    job_status_q = $rabbitmq_channel.queue( job_status_queue, auto_delete: false, durable: true )
    job_status_q.delete
  end
end
