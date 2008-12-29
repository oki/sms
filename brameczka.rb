#!/usr/local/bin/ruby

require 'net/http'
require 'uri'

class Brameczka
    HEADERS = {
      'Host' => 'brameczka.pl',
      'User-Agent' => 'Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; pl; rv:1.9.0.2) Gecko/2008091618 Firefox/3.0.2',
      'Referer' => 'http://brameczka.pl/',
      'Accept' => 'image/png,image/*;q=0.8,*/*;q=0.5',
      'Accept-Language' => 'pl,en-us;q=0.7,en;q=0.3',
      'Accept-Charset' => 'ISO-8859-2,utf-8;q=0.7,*;q=0.7',
    }

    class<<self
        def sms(params)
            dest    = params[:number]
            message = params[:message]
            from    = params[:from]

            # validate params, TODO

            http = Net::HTTP.new('www.brameczka.pl', 80)
            # with http proxy, more: http://lista-proxy.net/proxy-lista
            # http = Net::HTTP.new('www.brameczka.pl', 80, '212.241.180.239', 81)

            resp, data = http.get('/', nil)
            cookie = resp.response['set-cookie']

            resp, data = http.get('/images/spacer.gif', HEADERS.merge({ 'Cookie' => cookie }))
            magic_cookie = resp.response['set-cookie']
            if magic_cookie =~ /a=(.*);/
                a = $1
                cookie.gsub!(/a=.*/,'a=' + a)
            end

            sleep 5

            # escape params
            val = URI.escape(message, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
            data = "status=send&siec=#{dest[0..2]}&nr=&number2=#{dest[3..8]}&tresc=#{val}&od=#{from}&x=62&y=12"
            resp, data = http.post('/?', data, HEADERS.merge({ 
               'Cookie' => cookie,
               'Content-Type' => 'application/x-www-form-urlencoded',
               'Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
            }))

            # parse output
            if data =~ /<font size="\+2">(.*?)<\/font>/
                puts "Status: #{$1}"
            end

            if data =~ /<center>(Zosta.*?)<\/center>/
                puts $1
            else
                puts "Klapa"
                f = File.new("log.html", "w")
                f.puts data
                f.close
            end

        end
    end
end

