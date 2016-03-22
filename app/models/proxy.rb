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
  end

  def im_core_up
    ImCore.send_message( ImCore::QUEUE_NAME, {
      event: 'up',
      ip: ip,
      source: ImCore::USERNAME,
      location: {
        countryCode: country.iso2
      },
      idFromSource: id.to_s
    } )
  end

  def perform( im_job )
    # TODO: move the following to Proxy model

    uri = URI.parse im_job.post_to
    http = Net::HTTP.new uri.host, uri.port
    post_back = Net::HTTP::Post.new uri.request_uri
    post_back.set_form_data( {
      attributes: {
        url: im_job.url
      }
    } )
    post_back_response = http.request post_back

    Rails.logger.info post_back_response.inspect
  end
end
