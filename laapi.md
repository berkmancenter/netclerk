Link Availability API
=====================

Amber can check links against any server supporting this API. This API
adheres to the JSON API 1.0 specification: http://jsonapi.org/

query
-----

Request to get the last known status of a URL as viewed from a country.

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

