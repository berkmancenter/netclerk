require 'csv'
#require 'net/pop'
require 'zip'

namespace :netclerk do
  desc 'Download HMA proxy list'
  task :hma => :environment do |task, args|
    task_start = Time.now
    netclerk_hma
    task_end = Time.now
    puts "*** time: #{task_end - task_start} ***"
  end

  desc 'Remove trailing slashes from existing pages'
  task :remove_slashes => :environment do |task, args|
    netclerk_remove_slashes
  end

  desc 'Load a directory of proxy lists, (one per iso2 country code) & scan all the sites'
  task :scan, [:input_dir] => :environment do |task, args|
    task_start = Time.now
    netclerk_scan args[:input_dir]
    task_end = Time.now
    puts "*** time: #{task_end - task_start} ***"
  end

  desc 'Create the statuses for all country/page pairs for a given date'
  task :status, [:date] => :environment do |task, args|
    netclerk_status args[:date]
  end
end

def netclerk_hma( )
  mail_path = Rails.root.join HMA::INBOX

  glob = Dir.glob "#{mail_path}/*.numfar"

  puts "Count: #{glob.count}"

  glob.each { |eml|
    email_file = File.open eml
    email = Mail.new email_file.read
    if email.has_attachments?
      puts "Subject: #{email.subject}"
      puts "Date: #{email.date}"

      a = email.attachments.first

      Dir.mktmpdir { |dir|
        zip_path = "#{dir}/proxies.zip"
        puts "Extracting to #{dir}"
        open( zip_path , 'wb' ) { |file| file.write a.read }

        Zip::File.open( zip_path ) { |zip_file|
          zip_file.each { |f|
            f_path = File.join( dir, f.name )
            puts "  #{f_path}"
            FileUtils.mkdir_p( File.dirname( f_path ) )
            zip_file.extract( f, f_path ) unless File.exist?( f_path )
          }

          netclerk_scan( "#{dir}/full_list/" )
        }
      }
    end

    email_file.close
    File.delete email_file
  }
end

def netclerk_remove_slashes( )
  Page.where( "url like '%/'" ).each { |p|
    p.update url: p.url[0..-2]
  }
end

def netclerk_scan( input_dir )
  usage = "usage: rake netclerk:scan['path/to/input_dir']"

  if input_dir.nil?
    puts usage
    return
  end

  if !Dir.exists? input_dir
    puts "#{input_dir} does not exist"
    return
  end

  # delete all old non-permanent proxies
  Proxy.where( permanent: false ).delete_all

  # delete old sidekiq queue (we didn't get to it yesterday)
  if Sidekiq::Queue.all.any?
    Sidekiq::Queue.all.first.clear
  end

  # read _reliable_list
  reliable_list = "#{input_dir}/_reliable_list.txt"
  reliable = File.exists?( reliable_list ) ? File.readlines( reliable_list ) : []

  country_proxies = []

  ent = Dir.entries input_dir
  ent.each { |f| 
    if f.present? && !File.directory?(f) && File.extname(f) == '.txt'
      iso2 = File.basename( f, '.txt' ).upcase
      country = Country.find_by_iso2 iso2
      next if country.nil?

      proxies = []

      country_file = File.open("#{input_dir}/#{f}", 'r').each_line do |line|
        proxies << line.strip if reliable.include? line
      end
      country_file.close

      if proxies.any?
        country_proxies << { country: country, proxies: proxies } 
      end
    end
  }

  country_proxies.sort_by { |cp| cp[ :proxies ].count }.each do |cp|
    country = cp[ :country ]
    proxies = cp[ :proxies ]

    #puts "  #{country.name}: #{ActionController::Base.helpers.pluralize(proxies.count, 'proxy')}"

    Page.requestable.find_each do |page|
      if page.failed_locally?
        page.mark_as_failed_today!
        next
      end

      page.reset_failures!

      if page.title.blank?
        title = Nokogiri::HTML(page.baseline_content).css('title').text.truncate(255)
        page.update!(title: title) if title.present?
      end

      proxies.each { |proxy| ProxyRequest.perform_async(country.id, page.id, proxy) }
    end
  end
end

def netclerk_status( date )
  date = date || Date.today.to_s

  Rails.logger.info "running netclerk_status for #{date}"

  count = Status.count
  Country.having_requests_on( date ).each { |c|
    Rails.logger.info c.name
    Page.all.each { |p|
      Status.create_for_date p, c, date
    }
  }

  Rails.logger.info "#{Status.count - count} statuses created"
end
