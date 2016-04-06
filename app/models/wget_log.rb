class WgetLog < ActiveRecord::Base
  has_many :wget_log_requests

  def self.from_file( file_path )
    log = WgetLog.new

    File.readlines( file_path ).each { |line|
      case line
      when /\AOpening WARC/
        log.warc_path = line.scan( /'(.*)'/ )[0][0]

      when /\AFINISHED/
        log.finished_at = DateTime.parse( line.scan( /--(.*)--/ )[0][0] )

      when /\ATotal wall clock time/
        log.total_time = line.scan( /: (.*)/ )[0][0]

      when /\ADownloaded/
        downloaded = line.scan( /: (.*) files, (.*) in (.*) \((.*)\)/ )
        log.file_count = downloaded[0][0].to_i
        log.download_time = downloaded[0][2]
      end
    }

    log
  end
end
