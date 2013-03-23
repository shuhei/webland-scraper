# Encoding: utf-8

require 'cgi'
require 'json'
require 'open-uri'

require './env'
EnvReader.read

def geocode(address)
  endpoint = "http://dev.virtualearth.net/REST/v1/Locations"
  params = {
    countryRegion: 'JP',
    addressLine: address,
    key: ENV['BING_API_KEY'],
    c: 'ja-jp'
  }
  query = params.map {|k, v| "#{k}=#{CGI::escape(v)}" }.join '&'
  url = "#{endpoint}?#{query}"
  parsed = JSON.parse URI.parse(url).read
  if (parsed['statusDescription'] == 'OK')
    parsed['resourceSets'][0]['resources'][0]['point']['coordinates']
  else
    nil
  end
end

puts geocode('北海道札幌市中央区大通西２８丁目２０３番１０')
