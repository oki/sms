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

require File.dirname(__FILE__) + '/brameczka'

FROM = "ja"

# ARGV[0] - numer tel
# ARGV[1] - wiadomosc

puts "Wysylam smsa do: #{ARGV[0]}"
Brameczka.sms(:number => ARGV[0], :from => FROM, :message => ARGV[1])
