require 'open-uri'
require 'net/http'

class Page < ActiveRecord::Base
  belongs_to :category

  def self.proxy_request_data(country, proxy, url)
    ProxyRequest.perform_async(country.id, self.id, proxy.id)
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
      } ).read.encode
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
    baseline = baseline_content
    return if baseline.nil?

    puts "create_proxy_requests #{url}"

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
