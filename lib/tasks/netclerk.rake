require 'csv'

namespace :netclerk do
  desc 'Load a directory of proxy lists, (one per iso2 country code) & scan all the sites'
  task :scan, [:input_dir] => :environment do |task, args|
    task_start = Time.now
    netclerk_scan args[:input_dir]
    task_end = Time.now
    puts "*** time: #{task_end - task_start} ***"
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
  reliable = File.readlines "#{input_dir}/_reliable_list.txt" || []

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

  Page.all.each { |p|
    p.create_proxy_requests
  }
end

