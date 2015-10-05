require 'spec_helper'

describe ( Laapi::RequestsController ) {
  let ( :r_attr_required ) {
    # move to factory
    {
      type: 'requests',
      attributes: {
        url: 'http://www.whitehouse.gov',
        country: 'US',
        isp: 'Harvard University',
        dns_ip: '8.8.8.8',
        request_ip: '128.103.65.74',
        request_headers: 'GET / HTTP/1.1\r\nHost: cyber.law.harvard.edu\r\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8\r\nUser-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36\r\nAccept-Language: en-US,en;q=0.8',
        redirect_headers: 'HTTP/1.1 301 Moved Permanently\r\nDate: Tue, 22 Sep 2015 18:09:23 GMT\r\nServer: Apache/2.4.7 (Ubuntu)\r\nLocation: https://cyber.law.harvard.edu',
        response_status: 200,
        response_headers_time: 1560,
        response_headers: 'Content-Length: 71396 Content-Type: text/html; charset=utf-8 X-Drupal-Cache: HIT P3P: CP="NON DSP COR ADM DEV IVA OTPi OUR LEG" X-Varnish: 1729378229 X-AH-Environment: prod ETag: "1405098578-1" Expires: Fri, 11 Jul 2014 17:10:59 GMT Cache-Control: max-age=0, no-cache Pragma: no-cache Date: Fri, 11 Jul 2014 17:10:59 GMT X-Cache: MISS from server1 X-Cache-Lookup: MISS from server1:3128 Via: 1.0 server1 (squid/3.1.10) Connection: close',
        response_content_time: 100,
        response_content: '<!DOCTYPE html> <html lang="en" dir="ltr"> <head> <title>Berkman Center</title> </head> <body> ...  </body> </html>'
      }
    }
  }

  describe ( 'GET requests/3' ) {
    it ( 'should return ok' ) {
      get :show, id: 3, format: :json
      response.code.should eq( '200' )
    }
  }

  describe ( 'POST requests' ) {
    context ( 'all required fields' ) {
      it ( 'should return ok' ) {
        post :create, data: r_attr_required, format: :json
        response.code.should eq( '200' )
      }
    }
  }
}
