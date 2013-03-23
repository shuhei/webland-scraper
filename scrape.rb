# encoding: utf-8

require 'mechanize'
require 'cgi'

class WebLand
  def initialize
    @agent = Mechanize.new
  end

  def start
    page = @agent.get search_url(1, 1)
    places = parsePage page
    places.each { |place| puts place }
  end

  private
  def search_url(tdk, page)
    endpoint = "http://www.land.mlit.go.jp/landPrice/SearchServlet"
    params = {
      MOD: 2,
      TDK: tdk.to_s.rjust(2, '0'),
      SKC: '',
      CHI: '',
      YFR: 2012,
      YTO: 2013,
      YOU: '',
      PFR: '',
      PTO: '',
      PG: page,
      LATEST_YEAR: 1
    }
    query = params.map { |k, v| "#{k}=#{v}" }.join('&')
    
    "#{endpoint}?#{query}"
  end

  def parsePage(page)
    page.search('.datalist').map do |datalist|
      place = {}
      keys = datalist.css '.dataheader'
      # Use xpath instead of css '.datavalue, .datavalue2' to keep the order of values.
      values = datalist.xpath './/div[@class="datavalue" or @class="datavalue2"]'
      keys.each_with_index do |key, index|
        key = key.content.strip
        valueNode = values[index]
        place[key] = case key
        when '価格(円/m²)', '地積(m²)'
          parseNumber(valueNode)
        when '鑑定評価書'
          parseLink(valueNode)
        else
          parseStr(valueNode)
        end
      end
      createPlace place
    end
  end

  def parseStr(node)
    node.children[0].content.strip
  end

  def parseNumber(node)
    parseStr(node).gsub(',', '').to_i
  end

  def parseLink(node)
    node.child['href']
  end

  def parseLifeline(node)
    node.xpath('./text()').content
  end

  def createPlace(place)
    {
      id: place['標準地番号'],
      date: place['調査基準日'],
      address: place['所在及び地番'],
      residence: place['住居表示'],
      price: place['価格(円/m²)'],
      transportation: place['交通施設、距離'],
      area: place['地積(m²)'],
      shape: place['形状（間口：奥行き）'],
      usage_class: place['利用区分、構造'],
      current_usage: place['利用現況'],
      lifeline: place['給排水等状況'],
      surround: place['周辺の土地の利用現況'],
      front_road: place['前面道路の状況'],
      other_road: place['その他の接面道路'],
      purpose: place['用途区分、高度地区、防火・準防火'],
      coverage: place['建ぺい率（%）、容積率（%）'],
      urban_plan: place['都市計画区域区分'],
      nature: place['森林法、公園法、自然環境等']
    }
  end
end

WebLand.new.start
