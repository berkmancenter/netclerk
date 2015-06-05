require 'open-uri'
require 'net/http'

class PageGroup
  include Sidekiq::Worker
  sidekiq_options retry: false, backtrace: true

  def perform(country_id, page_ids, proxy_id_or_address)
    country = Country.find(country_id)
    pages = Page.find(page_ids)
    if proxy_id_or_address.is_a? Fixnum
      proxy = Proxy.find proxy_id_or_address
      proxy_id = proxy.id
      proxy_ip = p.ip
      proxy_port = p.port
    else
      parts = proxy_id_or_address.split ':'
      proxy_id = nil
      proxy_ip = parts[0]
      proxy_port = parts[1].to_i
    end

    requests = []

    pages.in_groups_of(10, false).each do |group|
      t = group.collect do |page|
        Thread.new do
          req = request_page(country, page, proxy_id, proxy_ip, proxy_port)
          requests << req if req
        end
      end

      while t.any? { |thr| thr.alive? } do
        sleep 0.1
      end
    end

    logger.info "CREATING REQUESTS: #{requests.size}"

    #Save Requests outside of Threads to minimize database connections.
    requests.each { |req| req.save }
    rescue StandardError => e
      logger.error "Failing Error: #{e.inspect}"
      raise e
  end

  def request_page(country, page, proxy_id, proxy_ip, proxy_port)
    baseline_content = page.baseline_content
    return if baseline_content.nil?

    time_start = Time.now

    uri = URI( page.url )

    req = create_request(uri)

    http = Net::HTTP.new(
      uri.hostname,
      uri.port,
      proxy_ip,
      proxy_port,
    )
    http.open_timeout = 5
    http.read_timeout = 10

    res = http.start{ |http| http.request req }

    response_time = Time.now - time_start

    proxy_content = res.body.encode

    return if proxy_content.nil?

    Request.new( {
      country_id: country.id,
      page_id: page.id,
      proxy_id: proxy_id,

      response_time: response_time,
      response_status: res.code.to_i,
      response_headers: res.to_hash.inspect,
      response_length: proxy_content.length,
      response_delta: Request.diff( baseline_content, proxy_content )
    } )
    rescue Net::OpenTimeout, Net::ReadTimeout, Errno::ECONNREFUSED, Errno::EHOSTUNREACH, Errno::ETIMEDOUT, EOFError, Net::HTTPBadResponse, Errno::ECONNRESET, Zlib::BufError
      return
    rescue StandardError => e
      logger.error "Ignoring Error: #{e.inspect}"
      nil
  end

  def create_request(uri)
    req = Net::HTTP::Get.new uri
    req['Accept'] = 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8'
    req['Accept-Language'] = 'en-US,en;q=0.8'
    req['Connection'] = 'close'
    req['User-Agent'] = 'Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1985.125 Safari/537.36'
    req
  end
end
