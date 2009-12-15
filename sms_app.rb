#!/usr/local/bin/ruby

# Tue Dec 30 11:10:50 CET 2008
# 
# konfiguracja smsow dla ekg z wykorzystaniem bramki: brameczka.pl
#
#
# cd ~/.gg/
# wget http://github.com/oki/sms/raw/master/brameczka.rb
# wget http://github.com/oki/sms/raw/master/sms_app.rb
# chmod 755 sms_app.rb
#
# ekg config
# /set sms_send_app /home/oki/.gg/sms_app.rb
#
# Dodawanie numerow telefonow do kontaktow
#
# /list oki -p 51x1x6x68
#
# Wysylanie smsa: 
#
# /sms oki to jest test smska ;-)
#
# gg: 442781, mail: oki malpa md6 kropka org

require 'pp'
require File.dirname(__FILE__) + '/brameczka'

def retryable_deluxe(options = {}, &block)
    opts = { :tries => 1, :on => { :exception => Exception, :return => false } }.merge(options)
    retry_opt, retries = opts[:on], opts[:tries]

    retry_exception = retry_opt[:exception]
    retry_return    = retry_opt[:return]

    retries_max = retries + 1

    begin
        puts "Attempt: #{retries_max-retries}"
        return yield == retry_return && raise(retry_exception,"#{retry_return}")
    rescue retry_exception => e
        retry if (retries -= 1) > 0
        raise "Zonk: #{e}"
    end
end

# ARGV[0] - numer tel
# ARGV[1] - wiadomosc
number = ARGV[0]
message = ARGV[1]
from = "ja"

retryable_deluxe(:tries => 10, :on => { :exception => Timeout::Error, :return => false }) do
    h_res = {}
    Timeout::timeout(30) {
        puts "Wysylam smsa do: #{number}"
        h_res = Brameczka.sms(:number => number, :from => from, :message => message)
        # h_res = { :status => "Sproboj za chwile", :count => "Testy, nic ci nie zostalo" }

        if h_res[:status] =~ /(?:Spr.buj za chwil.|Wyst.pi. b..d|Spr.buj ponownie|Tymczasowy problem))/
            puts "Blad: #{h_res[:status].gsub(/<br>.*/,'')} - ponawiam probe"
            false
        else
            puts "To: #{number}"
            puts "Body: #{message}"
            puts "Status: #{h_res[:status]}"
            puts "#{h_res[:count]}"
        end
    }
end
