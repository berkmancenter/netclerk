class WgetLog < ActiveRecord::Base
  has_many :requests, foreign_key: 'wget_log_id', class_name: 'WgetLogRequest'

  def self.from_file( file_path )
    log = WgetLog.new

    req = nil

    File.readlines( file_path ).each { |line|
      case line
      when /\AOpening WARC/
        log.warc_path = line.scan( /'(.*)'/ )[0][0]

      when /\AFINISHED/
        log.finished_at = DateTime.parse( line.scan( /--(.*)--/ )[0][0] )

      when /\ATotal wall clock time/
        log.total_time = line.scan( /: (.*)/ )[0][0]

      when /\ADownloaded/
        downloaded = line.scan /: (.*) files, (.*) in (.*) \((.*)\)/
        log.file_count = downloaded[0][0].to_i
        log.download_time = downloaded[0][2]

      when /\A--\d\d\d\d-\d\d-\d\d/
        req = log.requests.build
        req_start = line.scan /\A--(.*)--  (.*)/
        req.requested_at = DateTime.parse( req_start[0][0] )
        req.url = req_start[0][1]

      when /\AConnecting to/
        connecting_to = line.scan /Connecting to (.*)? \((.*)?\)\|(.+)\|:(\d*)/
        req.host = connecting_to[0][1]
        req.ip_v4 = connecting_to[0][2]
        req.port = connecting_to[0][3]

      when /\AHTTP request sent/
        req.response_code = line.scan( /(\d\d\d)/ )[0][0]

      when /\ALocation/
        req.is_redirect = line.match( /following/ ).present?
        req.redirect_location = line.scan( /Location: (.*)? \[following\]/ )[0][0]

      when /\ASaving to/
        req.saved_path = line.scan( /Saving to: '(.*)?'/ )[0][0]

      when /saved \[(\d*)?\]/
        saved = line.scan /\((.*)?\) - .*? saved \[(\d*)?\]/
        req.download_speed = saved[0][0]
        req.saved_length = saved[0][1].to_i

      when /\ALength/
        len = line.scan /Length: (.*)? \[(.*)?\]/
        if len[0][0] == 'unspecified'
          req.specified_length = nil
        else
          req.specified_length = len[0][0].scan( /(\d+)/ )[0][0].to_i
        end

        req.specified_mime_type = len[0][1]

      end
    }

    log
  end

  def request_count
    requests.to_set.count
  end
end
