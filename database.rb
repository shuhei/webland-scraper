require 'mongo'
include Mongo

class Database
  attr_reader :places
  
  def initialize
    @mongo = MongoClient.new
    @db = @mongo.db 'webland'

    @places = @db.collection 'places'
    index = { place_id: 1 }
    @places.ensure_index index
  end

  def save(doc)
    query = { place_id: doc[:place_id] }
    options = { upsert: true }
    @places.update query, doc, options
  end

  def find()
    @places.find
  end
end