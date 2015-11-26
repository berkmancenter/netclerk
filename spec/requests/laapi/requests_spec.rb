require 'spec_helper'

describe ( 'requests requests' ) {

  context ( 'JSON' ) {
    context ( 'with all required fields' ) {
      describe ( 'post /laapi/requests.json' ) {
        before {
          post "#{laapi_requests_path}", format: :json, data: {
            type: 'requests',
            attributes: {
              url: "http://cyber.law.harvard.edu",
              country: "IR",
              isp: "Harvard University",
              dns_ip: "8.8.8.8",
              request_ip: "128.103.65.74",
              request_headers: "GET / HTTP/1.1\r\nHost: cyber.law.harvard.edu\r\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8\r\nUser-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36\r\nAccept-Language: en-US,en;q=0.8",
              redirect_headers: "HTTP/1.1 301 Moved Permanently\r\nDate: Tue, 22 Sep 2015 18:09:23 GMT\r\nServer: Apache/2.4.7 (Ubuntu)\r\nLocation: https://cyber.law.harvard.edu",
              response_status: 200,
              response_headers_time: 1560,
              response_headers: "HTTP/1.1 200 OK\r\nDate: Tue, 22 Sep 2015 18:09:23 GMT\r\nServer: Apache/2.4.7 (Ubuntu)\r\nContent-Language: en\r\nContent-Encoding: gzip\r\nContent-Type: text/html; charset=utf-8",
              response_content_time: 4560,
              response_content: "<!DOCTYPE html> <html lang=\"en\" dir=\"ltr\"> <head> <title>Berkman Center</title> </head> <body> ...  </body> </html>"
            }
          }
        }

        it {
          #puts page.source
          skip 'page.status_code.should eq( 200 )'
        }
      }
    }
  }
}
