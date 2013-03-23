require 'json'
require './database'

db = Database.new

isFirst = true
print '['
db.places.find.each do |place|
  lat = place['lat']
  lng = place['lng']
  price = place['price']
  next if lat.nil? || lng.nil? || lat == 0 || lng == 0 || price.nil?

  if isFirst
    isFirst = false
  else
    print ','
  end
  print "#{lat},#{lng},#{price}"
end
print ']'
