#!/bin/sh
wget --page-requisites --html-extension --convert-links --save-cookies=content/cookies.txt --no-check-certificate --directory-prefix=content --output-file=content/wget.log http://cyber.law.harvard.edu/node/99235 --warc-file=content/cyber.law.harvard.edu-node-99235 --no-warc-compression


# NetClerk => laapi
# What we get and where we get it
# 
# id
# from IM Core as part of the postTo URL
# 
# url
# wget log, url, of 1st non-[following] request
# 
# asn
# ?
# 
# request_ip
# wget log, ip address, of 1st non-[following] request
# 
# request_headers
# warc, request headers, after following any redirects
# 
# redirect_headers
# warc, response headers, of all response sections for all redirects
# 
# response_headers
# warc, response headers, after following any redirects
# 
# certificate_chain
# openssl, openssl s_client -connect {HOSTNAME}:{PORT} -showcerts
#
# status_code
# wget log, response code, of 1st non-[following] request
# 
# errors
# warc?
#
# timeline
# wget log, request + total size=response time, for all requests
#
# raw_content
# html, response html of main request,
#
# page_complete
# n/a?
#
# page_warc
# warc
#
# page_screenshot
# pantomjs

