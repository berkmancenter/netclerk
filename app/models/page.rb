require 'open-uri'
require 'net/http'

class Page < ActiveRecord::Base
  belongs_to :category

  def self.proxy_request_data( url, proxy_ip_and_port, baseline_test )
    request_data = nil
    response_length = 0

    time_start = Time.now

    begin
      uri = URI( url )

      req = Net::HTTP::Get.new uri
      req['Accept'] = 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8'
      #req['Accept-Encoding'] = 'gzip,deflate' # added automatically by Net::HTTP
      req['Accept-Language'] = 'en-US,en;q=0.8'
      req['Connection'] = 'close'
      req['User-Agent'] = 'Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1985.125 Safari/537.36'

      proxy = proxy_ip_and_port.split ':'

      res = Net::HTTP.start( uri.hostname, uri.port, proxy[0], proxy[1].to_i, { open_timeout: 5, read_timeout: 30 } ) { |http|
        http.request req
      }

      response_time = Time.now - time_start

      #puts "      time: #{response_time}"

      #puts "      status: #{res.code.to_i}"

      #puts "      headers: #{res.to_hash.inspect}"

      proxy_content = res.body

      request_data = {
        response_time: response_time,
        response_status: res.code.to_i,
        response_headers: res.to_hash.inspect,
        response_length: proxy_content.length,
        response_delta: Request.diff( baseline_test, proxy_content )
      }

    rescue Net::OpenTimeout
      rescue_time = Time.now - time_start
      #puts "     time: #{rescue_time}"

      puts 'Net::OpenTimeout'
    rescue Net::ReadTimeout
      rescue_time = Time.now - time_start
      #puts "     time: #{rescue_time}"

      puts 'Net::ReadTimeout'
    rescue Zlib::BufError
      # So, this can happen.
      rescue_time = Time.now - time_start
      #puts "     time: #{rescue_time}"

      puts 'Zlib::BuffError'
    rescue EOFError
      # This, too.
      rescue_time = Time.now - time_start
      #puts "     time: #{rescue_time}"

      puts 'EOFError'
    rescue Exception => e
      rescue_time = Time.now - time_start
      #puts "     time: #{rescue_time}"

      if e === Errno::ECONNRESET
        puts 'Errno::ECONNRESET'
      elsif e === Errno::ECONNREFUSED
        puts 'Errno::ECONNREFUSED'
      elsif e === Errno::ETIMEDOUT
        puts 'Errno::TIMEDOUT'
      else
        puts 'Unknown Exception'
      end
    end

    request_data
  end

  def baseline_content
    content = nil
    begin
      content = open( url, {
        redirect: false,
        'Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
        #'Accept-Encoding' => 'gzip,deflate', # added automatically by Net::HTTP
        'Accept-Language' => 'en-US,en;q=0.8',
        'Connection' => 'close',
        'User-Agent' => 'Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1985.125 Safari/537.36',
      } ).read
    rescue OpenURI::HTTPRedirect => e
      # update our url and try again another day
      puts "  #{url} => #{e.uri}"
      self.url = e.uri.to_s
      save
    rescue SocketError
      puts '  SocketError (consider removing from NetClerk)'
    end

    content
  end

  def create_proxy_requests
    puts "create_proxy_requests #{url}"

    baseline = baseline_content
    return if baseline.nil?

    Country.all.each { |c|
      next unless c.proxies.count > 0

      puts "  #{c.name}: #{c.proxies.count} proxies"

      c.proxies.each { |p|
        puts "    #{p.ip_and_port}"

        baseline_test = baseline

        request_data = Page.proxy_request_data url, p.ip_and_port, baseline_test

        if request_data.present?
          request = Request.new( request_data )
          request.country_id = c.id
          request.page_id = id
          request.proxy_id = p.id
          request.save


          puts request.inspect
        end
      }
    }
  end
end
