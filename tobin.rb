require 'json'

json = open('prices.json').read
parsed = JSON.parse(json)

open('prices.data', 'w') do |f|
  parsed.each.with_index do |num, i|
    case i % 3
    # Big Endian 32 bit float
    when 0 then f.write([num].pack('g'))
    when 1 then f.write([num].pack('g'))
    # Big Endian 32 bit integer
    when 2 then f.write([num].pack('N'))
    end
  end
end
