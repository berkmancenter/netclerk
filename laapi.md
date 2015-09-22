Link Availability API
=====================

Third parties can check links against any server supporting this API. This API
adheres to the JSON API 1.0 specification: http://jsonapi.org/

The NetClerk Link Availability API endpoint is at /laapi. For example, to query statuses send a GET request to /laapi/statuses, and to tell us of a request you have made send a POST request to /laapi/requests.

query statuses
--------------

Send GET or POST requests to /statuses to retrieve the last known status of a URL as viewed from a given country.

**For readability, the url parameters are shown unencoded. In practice,
these values must be percent-encoded as per the HTTP spec.**

    GET /statuses?url=[URL]&country=[ISO2] HTTP/1.1
    Accept: application/vnd.api+json

Multiple URLs can be queried in one request by formatting the url query
parameter with multi-value syntax:

    GET /statuses?url[]=[URL1]&url[]=[URL2]&country=[ISO2] HTTP/1.1
    Accept: application/vnd.api+json

Since multiple URLs can easily surpass the maximum size of a single URL,
the query can be sent via HTTP POST as long as the Content-Type HTTP is
specified and set to application/x-www-form-urlencoded. The url\[\]
parameters must still be percent-encoded in practice.

    POST /statuses HTTP/1.1
    Content-Type: application/x-www-form-urlencoded
    Accept: application/vnd.api+json

    url[]=[URL1]&url[]=[URL2]&country=[ISO2]

### Example: site returned content but too different from expected

    GET /statuses?url=http://www.bbc.com/news/world-us-canada-33815974&country=IR

    HTTP/1.1 200 OK
    Content-Type: application/vnd.api+json

    {
      "data": [ {
        "type": "statuses",
        "id": "774238",
        "attributes": {
          "url": "http://www.bbc.com/news/world-us-canada-33815974",
          "code": 200
          "probability": 0.25
          "available": false,
          "created": "2015-08-07T00:00:00.000Z"
        }
      } ]
    }

### Example: site returned content similar to expected

    GET /statuses?url=https://cyber.law.harvard.edu/node/99048&country=TR

    HTTP/1.1 200 OK
    Content-Type: application/vnd.api+json

    {
      "data": [ {
        "type": "statuses",
        "id": "783874",
        "attributes": {
          "url": "https://cyber.law.harvard.edu/node/99048",
          "code": 200
          "probability": 0.80
          "available": true,
          "created": "2015-08-07T00:00:00.000Z"
        }
      } ]
    }

### Example: URL has not been tested from the given country

    GET /statuses?url=http://www.nytimes.com/interactive/2015/08/07/us/politics/republican-candidates-debate.html&country=JP

    HTTP/1.1 200 OK
    Content-Type: application/vnd.api+json

    {
      "data": [ ]
    }

### Example: querying multiple URLs in one request

**Note** All URLs will be checked from the given country.

    GET /statuses?url[]=http://www.bbc.com/news/world-us-canada-33815974&url[]=https://cyber.law.harvard.edu/node/99048&country=IR

    HTTP/1.1 200 OK
    Content-Type: application/vnd.api+json

    {
      "data": [ {
        "type": "statuses",
        "id": "774238",
        "attributes": {
          "url": "http://www.bbc.com/news/world-us-canada-33815974",
          "code": 200
          "probability": 0.25
          "available": false,
          "created": "2015-08-07T00:00:00.000Z"
        }
      }, {
        "type": "statuses",
        "id": "783874",
        "attributes": {
          "url": "https://cyber.law.harvard.edu/node/99048",
          "code": 200
          "probability": 0.80
          "available": true,
          "created": "2015-08-07T00:00:00.000Z"
        }
      } ]
    }

### Example: querying multiple URLs, only one of which has been tested

**Note** Only statuses known will be returned, URLs unchecked from the
given country will be omitted from the data array in the response.

    GET /statuses?url[]=http://www.nytimes.com/interactive/2015/08/07/us/politics/republican-candidates-debate.html&url[]=https://cyber.law.harvard.edu/node/99048&country=IR

    HTTP/1.1 200 OK
    Content-Type: application/vnd.api+json

    {
      "data": [ {
        "type": "statuses",
        "id": "783874",
        "attributes": {
          "url": "https://cyber.law.harvard.edu/node/99048",
          "code": 200
          "probability": 0.80
          "available": true,
          "created": "2015-08-07T00:00:00.000Z"
        }
      } ]
    }

**Note** While not guaranteed by this API, an implementation is
generally expected to test the given URL within 24 hours. This does not
imply that any given implementation is capable of testing the given URL
in the country requested, however, it is not unreasonabe for a client
(such as Amber) to try again with the same URL/country pair at a later
date.

response attributes
-------------------

### url

The URL to which the given status object applies.

### code

Most common HTTP status code returned to clients requesting the given
URL from the given country.

### probability

Probability that the **site is available** and that the content is
similar enough to what is expected. Do not mistake this as “confidence
that the value supplied for availabe is correct.”

### available

Decision on whether or not a given URL is available in a given country.

### created

Date & time the URL was last checked in the given country.

### other attributes

The server may return more attributes not defined in this spec. The
attributes can be specific to the server’s method of testing and
implementation.

tell us about a request (successful or not)
-------------------------------------------

Send POST requests to /requests to let us know that you have tested the availability of a URL from a country and logged some info about the response. Anything you can do to help us will help others know more about what is available online around the world.

Before submitting request data to us, you will have to sign into NetClerk and request an API key. If you cannot sign into NetClerk, please email help@netclerk.thenetnomitor.org.

All POSTs to /requests will have the Content-Type multipart/form-data. The following attributes are required when submitting a successful test of a web page:

* url
* country
* request_headers
* response_time
* response_status
* response_headers
* response_content

The server will respond with a JSON respresentation of the new request including its unique id. However, note that the test data you submitted may not automatically affect the data in /statuses as further analysis may be scheduled for a later time.

### Example: sending a test you performed to NetClerk

    POST /requests
    Content-Type: multipart/form-data; boundary=~~~~--
    Accept: application/vnd.api+json
    
    --~~~~--
    Content-Disposition: form-data; name="url"
    
    http://cyber.law.harvard.edu
    --~~~~--
    Content-Disposition: form-data; name="country"
    
    IR
    --~~~~--
    Content-Disposition: form-data; name="isp"
    
    Harvard University
    --~~~~--
    Content-Disposition: form-data; name="dns_ip"
    
    8.8.8.8
    --~~~~--
    Content-Disposition: form-data; name="request_ip"
    
    128.103.65.74
    --~~~~--
    Content-Disposition: form-data; name="request_headers"

    GET / HTTP/1.1
    Host: cyber.law.harvard.edu
    Connection: keep-alive
    Cache-Control: max-age=0
    Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
    Upgrade-Insecure-Requests: 1
    User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/45.0.2454.93 Safari/537.36
    Accept-Encoding: gzip, deflate, sdch
    Accept-Language: en-US,en;q=0.8
    --~~~~--
    Content-Disposition: form-data; name="redirect_headers"
    
    HTTP/1.1 301 Moved Permanently
    Date: Tue, 22 Sep 2015 18:09:23 GMT
    Server: Apache/2.4.7 (Ubuntu)
    X-Powered-By: PHP/5.5.9-1ubuntu4.4
    X-Drupal-Cache: HIT
    Location: https://cyber.law.harvard.edu
    Cache-Control: max-age=600, private, must-revalidate
    Expires: Sun, 19 Nov 1978 05:00:00 GMT
    Vary: Cookie,Accept-Encoding
    Content-Encoding: gzip
    Content-Length: 41
    Content-Type: text/html; charset=UTF-8
    Via: 1.1 cyber.law.harvard.edu
    Keep-Alive: timeout=5, max=100
    Connection: Keep-Alive
    --~~~~--
    Content-Disposition: form-data; name="response_time"

    5.56
    --~~~~--
    Content-Disposition: form-data; name="response_status"
    
    200
    --~~~~--
    Content-Disposition: form-data; name="response_headers"
    
    HTTP/1.1 200 OK
    Date: Tue, 22 Sep 2015 18:09:23 GMT
    Server: Apache/2.4.7 (Ubuntu)
    X-Powered-By: PHP/5.5.9-1ubuntu4.4
    X-Drupal-Cache: HIT
    Content-Language: en
    X-UA-Compatible: IE=edge,chrome=1
    X-Generator: Drupal 7 (http://drupal.org)
    Cache-Control: max-age=600, private, must-revalidate
    Expires: Sun, 19 Nov 1978 05:00:00 GMT
    Vary: Cookie,Accept-Encoding
    Content-Encoding: gzip
    Content-Type: text/html; charset=utf-8
    Via: 1.1 cyber.law.harvard.edu
    Keep-Alive: timeout=5, max=100
    Connection: Keep-Alive
    Transfer-Encoding: chunked
    --~~~~--
    Content-Disposition: form-data; name="response_length"

    9323
    --~~~~--
    Content-Disposition: form-data; name="response_content"; filename="response.html"
    Content-Type: text/html
    
    <!DOCTYPE html>
    <html lang="en" dir="ltr">

    <head>
      <title>Berkman Center</title>
    </head>
    <body>
      ...
    </body>
    </html>
    --~~~~--
    Content-Disposition: form-data; name="page_complete"; filename="page.tar.gz"
    Content-Type: application/gzip
    
    1f8bd57a7d85ab8d5a7895db7859a7b95a98d757ad75ad85b789a7b57ad...
    --~~~~--
    Content-Disposition: form-data; name="page_warc"; filename="page.warc.gz"
    Content-Type: application/gzip
    
    1f8bfe73f6458f5f9e70678ef06e89f0eb7b89678b068906b0896b68900...
    --~~~~--
    

    


