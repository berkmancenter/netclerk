require 'open-uri'

class Page < ActiveRecord::Base
  belongs_to :category

  def create_proxy_requests
    puts "create_proxy_requests #{url}"

    baseline_content = open( url, {
      'Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
      'Accept-Encoding' => 'gzip,deflate,sdch',
      'Accept-Language' => 'en-US,en;q=0.8',
      'Connection' => 'close',
      'User-Agent' => 'Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1985.125 Safari/537.36',
    } ).read

    Country.all.each { |c|
      next unless c.proxies.count > 0

      puts "  #{c.name}"

      c.proxies.each { |p|
        #puts "  #{p.ip_and_port}"

        baseline_test = baseline_content

        response_length = 0

        time_start = Time.now

        begin
          proxy_connection = open url, {
            'Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
            'Accept-Encoding' => 'gzip,deflate,sdch',
            'Accept-Language' => 'en-US,en;q=0.8',
            'Connection' => 'close',
            'User-Agent' => 'Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1985.125 Safari/537.36',
            proxy: "http://#{p.ip_and_port}",
            content_length_proc: lambda { |t|
              response_length = t
            }
          }

          response_time = Time.new - time_start

          #puts "time: #{response_time}"

          #puts "status: #{proxy_connection.status}"

          #puts "headers: #{proxy_connection.meta.to_s}"

          proxy_content = proxy_connection.read

          request = Request.create(
            country_id: c.id,
            proxy_id: p.id,
            response_time: response_time,
            response_status: proxy_connection.status,
            response_headers: proxy_connection.meta.to_s,
            response_length: response_length,
            response_delta: Request.diff( baseline_test, proxy_content )
          )

          proxy_connection.close

          puts request.inspect
        rescue Exception # Errno:ECONNRESET is sadly super generic
          puts 'Errno::ECONNRESET'
        end
      }

    }

    #puts '***'
    #puts baseline
    #puts '***'

  end
end
