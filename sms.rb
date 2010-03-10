#!/usr/local/bin/ruby

require 'brameczka'
require 'yaml'
require 'pp'

abook = YAML.load(IO.read('abook.yaml'))
response = Brameczka.sms(:number => abook[:ja], :from => "michal", :message => "zonkownia")
pp response
