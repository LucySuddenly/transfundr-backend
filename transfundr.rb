#!/usr/bin/env ruby

require 'rubygems'
require 'chatterbot/dsl'

def tweet_beacon(url, title)
    tweet "New Beacon: #{title}! Please visit #{url} and consider donating! #transfundr"
end