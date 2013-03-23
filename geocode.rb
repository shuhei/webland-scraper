# Encoding: utf-8

require 'cgi'
require 'json'
require 'parallel'
require 'open-uri'

require './env_reader'
EnvReader.read

require './database'

def geocode(address)
  endpoint = 'http://dev.virtualearth.net/REST/v1/Locations'
  params = {
    countryRegion: 'JP',
    addressLine: address,
    key: ENV['BING_API_KEY'],
    c: 'ja-jp'
  }
  query = params.map {|k, v| "#{k}=#{CGI::escape(v)}" }.join '&'
  url = "#{endpoint}?#{query}"

  begin
    io = open(url)
  rescue
    puts "Error to open #{url}"
    return nil
  end

  parsed = JSON.parse io.read
  return nil unless parsed['statusDescription'] == 'OK'

  resources = parsed['resourceSets'][0]['resources']
  return [0,0] if resources.size == 0
  
  resources[0]['point']['coordinates']
end

count = 0
db = Database.new

while db.places.count(query: { lat: nil }) > 0
  places = db.places.find({ lat: nil }).limit(10).to_a
  Parallel.each(places, in_threads: 10) do |place|
    if coords = geocode(place['address'])
      lat, lng = coords
      puts "#{count}: #{place['address']} => #{lat}, #{lng}"
      db.places.update({ _id: place['_id'] }, { '$set' => { lat: lat, lng: lng } })
    else
      puts "#{count}: #{place['address']} => Failed to geocode."
    end
    count += 1
  end
end
