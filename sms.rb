#!/usr/local/bin/ruby

require 'net/http'
require 'uri'

#cookie = res.response['set-cookie']
#puts cookie

#url = URI.parse('http://www.brameczka.pl/')

#req = Net::HTTP::Post.new("/?")
#req.body = "status=send&siec=510&nr=&number2=166268&tresc=Dupa+jasia&od=oki&x=63&y=14"

#res = Net::HTTP.new(url.host, url.port).start {|http| http.request(req) }
#body = res.body

http = Net::HTTP.new('www.brameczka.pl', 80)
# http = Net::HTTP::Proxy.new('www.brameczka.pl', 80)
path = '/'

# GET request -> so the host can set his cookies
resp, data = http.get(path, nil)
cookie = resp.response['set-cookie']

resp, data = http.get('/images/spacer.gif', {
  'Cookie' => cookie,
  'Host' => 'brameczka.pl',
  'User-Agent' => 'Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; pl; rv:1.9.0.2) Gecko/2008091618 Firefox/3.0.2',
  'Referer' => 'http://brameczka.pl/',
  'Accept' => 'image/png,image/*;q=0.8,*/*;q=0.5',
  'Accept-Language' => 'pl,en-us;q=0.7,en;q=0.3',
  'Accept-Encoding' => 'gzip,deflate',
  'Accept-Charset' => 'ISO-8859-2,utf-8;q=0.7,*;q=0.7',
})

img_cookie = resp.response['set-cookie']
###! puts img_cookie

a = ''
if img_cookie =~ /a=(.*);/
    a = $1
    puts "a:#{a}"
end
###! puts cookie

# cookie.gsub!(/a=.*/,'a=7dc917ed74f3e66398c9396fa005cd05')
cookie.gsub!(/a=.*/,'a=' + a)
cookie.gsub!(/\.pl,/,'.pl;')
###! puts cookie

sleep 5

# POST request -> logging in
#data = "status=send&siec=510&nr=&number2=166268&tresc=XTest+ze+skryptu&od=test&x=62&y=12"
#data = "status=send&siec=XXX&nr=&number2=881864&tresc=Test+ze+skryptu&od=oki&x=62&y=12"
headers = {
   'Cookie' => cookie,
   'Content-Type' => 'application/x-www-form-urlencoded',
   'Host' => 'brameczka.pl',
   'User-Agent' => 'Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; pl; rv:1.9.0.2) Gecko/2008091618 Firefox/3.0.2',
   'Referer' => 'http://brameczka.pl/',
   'Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
   'Accept-Language' => 'pl,en-us;q=0.7,en;q=0.3',
   'Accept-Charset' => 'ISO-8859-2,utf-8;q=0.7,*;q=0.7',
}

resp, data = http.post('/?', data, headers)

if data =~ /<font size="\+2">(.*?)<\/font>/
    puts "Status: #{$1}"
end

if data =~ /Zosta.o.*?(\d+)/
    puts "Zostalo #{$1} SMS'ow na dzis"
else
    puts "Klapa"
end
