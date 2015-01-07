require 'csv'

namespace :netclerk do
  desc 'Download HMA proxy list'
  task :hma, [:dst_dir] => :environment do |task, args|
    pop = Net::POP3.new( )
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

  # read _reliable_list
  reliable_list = "#{input_dir}/_reliable_list.txt"
  reliable = File.exists?( reliable_list ) ? File.readlines( reliable_list ) : []

  ent = Dir.entries input_dir
  ent.each { |f| 
    if f.present? && !File.directory?(f) && File.extname(f) == '.txt'
      iso2 = File.basename( f, '.txt' ).upcase
      country = Country.find_by_iso2 iso2
      next if country.nil?

      File.open("#{input_dir}/#{f}", 'r').each_line do |line|
        Proxy.create( ip_and_port: line, permanent: false, country: country ) if reliable.include? line
      end
    end
  }

  Page.all.each do |page|
    Country.all.each do |country|
      next unless country.proxies.count > 0
      puts "  #{country.name}: #{country.proxies.count} proxies"
      country.proxies.each do |proxy|
        ProxyRequest.perform_async(country.id, page.id, proxy.id)
      end
    end
  end
end

def netclerk_status( date )
  usage = "usage: rake netclerk:status['YYYY-MM-DD']"

  if date.nil?
    puts usage
    return
  end

  count = Status.count
  Country.all.each { |c|
    puts c.name
    Page.all.each { |p|
      Status.create_for_date p, c, date
    }
  }

  puts "#{Status.count - count} statuses created"
end
