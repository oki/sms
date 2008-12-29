#!/usr/local/bin/ruby

require 'brameczka'
require 'yaml'

abook = YAML.load(IO.read('abook.yaml'))

Brameczka.sms(:number => abook[:ja], :from => "oki", :message => "To jest testowa wiadomosc :-)")
