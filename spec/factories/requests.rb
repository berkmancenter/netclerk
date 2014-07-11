FactoryGirl.define do
  factory :request do
    factory :whitehouse_usa_r01 do
      #page whitehouse
      #country usa
      #proxy proxy_usa
      unproxied_ip '72.247.10.26'
      proxied_ip nil
      local_dns_ip nil
      response_time 100 # ms
      response_status 200
      response_headers %[Content-Length: 71396
Content-Type: text/html; charset=utf-8
X-Drupal-Cache: HIT
P3P: CP="NON DSP COR ADM DEV IVA OTPi OUR LEG"
X-Varnish: 1729378229
X-AH-Environment: prod
ETag: "1405098578-1"
Expires: Fri, 11 Jul 2014 17:10:59 GMT
Cache-Control: max-age=0, no-cache
Pragma: no-cache
Date: Fri, 11 Jul 2014 17:10:59 GMT
X-Cache: MISS from server1
X-Cache-Lookup: MISS from server1:3128
Via: 1.0 server1 (squid/3.1.10)
Connection: close]
      response_length 71396
      response_delta 0.05
    end
  end
end
