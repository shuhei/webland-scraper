# Fetch land prices from MLIT's website

Make sure MongoDB is running on localhost.

Scrape land prices, get geo coordinates from addresses and export them.

```
bundle install
ruby scrape.rb
ruby geocode.rb
ruby export.rb > prices.json
ruby tobin.rb
```
