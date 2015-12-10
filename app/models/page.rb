require 'open-uri'
require 'net/http'

class Page < ActiveRecord::Base
  has_and_belongs_to_many :categories
  has_many :statuses

  validates :url, length: { maximum: 2048 }
  validates_format_of :url, without: /\/\Z/

  before_validation :strip_trailing_slash

  scope :requestable, -> { where('fail_count < 3') }
  scope :category, -> (category_name) { joins(:categories).where("categories.name = ?", category_name) }

  def self.proxy_request_data(country, proxy, url)
    ProxyRequest.perform_async(country.id, self.id, proxy.id)
  end

  def strip_trailing_slash
    if url[-1] == '/'
      self.url = url[0..-2]
    end
  end

  def baseline_content
    Rails.cache.fetch( url, expires_in: 6.hours ) do
      bc = nil
      begin
        Timeout::timeout( 2 ) {
          bc = open( url, {
            redirect: false,
            'Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
            #'Accept-Encoding' => 'gzip,deflate', # added automatically by Net::HTTP
            'Accept-Language' => 'en-US,en;q=0.8',
            'Connection' => 'close',
            'User-Agent' => 'Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1985.125 Safari/537.36',
          } ).read.encode
        }
      rescue OpenURI::HTTPRedirect => e
        # update our url and try again another day
        Rails.logger.info "Redirect: #{url} => #{e.uri}"
        self.url = e.uri.to_s
        save
      rescue Timeout::Error => e
        Rails.logger.error "Timeout::error (baseline_content): #{url} (consider removing from NetClerk)"
      rescue OpenURI::HTTPError => e
        Rails.logger.error "HTTPError (baseline_content): #{url} (consider removing from NetClerk)"
      rescue OpenSSL::SSL::SSLError => e
        Rails.logger.error "OpenSSL::SSL::SSLError (baseline_content): #{url} (consider removing from NetClerk)"
      rescue Errno::ECONNRESET => e
        Rails.logger.error "Errno::ECONNRESET (baseline_content): #{url} (consider removing from NetClerk)"
      rescue Errno::ECONNREFUSED => e
        Rails.logger.error "Errno::ECONNREFUSED (baseline_content): #{url} (consider removing from NetClerk)"
      rescue Errno::ETIMEDOUT => e
        Rails.logger.error "Errno::ETIMEDOUT (baseline_content): #{url} (consider removing from NetClerk)"
      rescue SocketError
        Rails.logger.error "SocketError (baseline_content): #{url} (consider removing from NetClerk)"
      rescue Exception => e
        Rails.logger.error "Exception #{e.inspect} (baseline_content): #{url} (consider removing from NetClerk)"
      end
      bc
    end
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

  def failed_locally?
    baseline_content.nil?
  end

  def mark_as_failed_today!
    return if failed_at == Date.current

    self.failed_at = Date.current
    self.fail_count += 1
    self.save!
  end

  def reset_failures!
    self.update!(failed_at: nil, fail_count: 0)
  end

  def category_names
    categories.pluck(:name)
  end
end
