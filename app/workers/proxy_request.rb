require 'open-uri'
require 'net/http'

class ProxyRequest
  include Sidekiq::Worker
  sidekiq_options retry: false, backtrace: true

  def perform(country_id, page_id, proxy_id)
    country = Country.find(country_id)
    page = Page.find(page_id)
    proxy = Proxy.find(proxy_id)

    request_data = nil
    response_length = 0

    logger.info "URL: #{page.url}"
    baseline_content = page.baseline_content
    return if baseline_content.nil?

    time_start = Time.now

      uri = URI( page.url )

      req = create_request(uri)

      http = Net::HTTP.new(
        uri.hostname,
        uri.port,
        proxy.ip,
        proxy.port,
      )
      http.open_timeout = 5
      http.read_timeout = 10
      #http.set_debug_output $stderr

      res = http.start{ |http| http.request req }

      response_time = Time.now - time_start

      #logger.info "      time: #{response_time}"
      #logger.info "      status: #{res.code.to_i}"
      #logger.info "      headers: #{res.to_hash.inspect}"

      proxy_content = res.body.encode

      return if proxy_content.nil?

      request_data = {
        response_time: response_time,
        response_status: res.code.to_i,
        response_headers: res.to_hash.inspect,
        response_length: proxy_content.length,
        response_delta: Request.diff( baseline_content, proxy_content )
      }

#    rescue Net::OpenTimeout
#      rescue_time = Time.now - time_start
#      logger.info "     time: #{rescue_time}"
#
#      logger.info 'Net::OpenTimeout'
#    rescue Net::ReadTimeout
#      rescue_time = Time.now - time_start
#      logger.info "     time: #{rescue_time}"
#
#      logger.info 'Net::ReadTimeout'
#    rescue Zlib::BufError
#      # So, this can happen.
#      rescue_time = Time.now - time_start
#      logger.info "     time: #{rescue_time}"
#
#      logger.info 'Zlib::BuffError'
#    rescue EOFError
#      # This, too.
#      rescue_time = Time.now - time_start
#      logger.info "     time: #{rescue_time}"
#
#      logger.info 'EOFError'
#    rescue Exception => e
#      rescue_time = Time.now - time_start
#      logger.info "     time: #{rescue_time}"
#
#      if e == Errno::ECONNRESET
#        logger.info 'Errno::ECONNRESET'
#      elsif e == Errno::ECONNREFUSED
#        logger.info 'Errno::ECONNREFUSED'
#      elsif e == Errno::ETIMEDOUT
#        logger.info 'Errno::ETIMEDOUT'
#      else
#        logger.info "Unknown Exception: #{e.inspect}"
#      end

    request = Request.new( request_data )
    request.country = country
    request.page = page
    request.proxy_id = proxy.id
    request.save

    #puts request.inspect
  end
  
  def create_request(uri)
    req = Net::HTTP::Get.new uri
    req['Accept'] = 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8'
    #req['Accept-Encoding'] = 'gzip,deflate' # added automatically by Net::HTTP
    req['Accept-Language'] = 'en-US,en;q=0.8'
    req['Connection'] = 'close'
    req['User-Agent'] = 'Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1985.125 Safari/537.36'
    req
  end
end
