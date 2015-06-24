module Werkzaamheden
  # This class defines a Werk object which is converted from XML
  class Werk
    TYPS = ["","Werkzaamheden zonder afsluiting","Werkzaamheden met afsluiting","Evenement zonder afsluiting","Evenement met afsluiting","Calamiteit met hinder","Calamiteit met afsluiting"]
    ZEKER = ["Voornemen","Voorbereiding","Definitief, publiceren","Definitief, niet publiceren"]
    HINDERKLASSEN = ["","Geen hinder (geen vertraging)","Kleine hinder (<5 min vertraging)","Beperkte hinder (5-10 min)","Grote hinder (10-30 min)","Zeer grote hinder (>30 min)"]
    attr_reader :typ, :hinderklasse, :wanneer, :start, :eind, :x, :y, :objectnummer, :titel, :level, :zeker, :projectnummer, :is_project

    def initialize(werk_xml)
      @typ = TYPS[werk_xml.css('Typ').text.to_i]
      @level = werk_xml.css('Level').text.to_i
      @objectnummer = werk_xml.css('Objectnummer').text.to_i
      @zeker = ZEKER[werk_xml.css('Zeker').text.to_i]
      @projectnummer = werk_xml.css('Projectnummer').text.to_i
      @hinderklasse = HINDERKLASSEN[werk_xml.css('Hinderklasse').text.to_i]
      @wanneer = uncode(werk_xml.css('Wanneer').text)
      @start = Date.parse(werk_xml.css('Begin').text)
      @eind = Date.parse(werk_xml.css('Eind').text)
      @titel = uncode(werk_xml.css('Titel').text)
      @x, @y = meters2degrees(werk_xml.css('x').text.to_f, werk_xml.css('y').text.to_f)
      @is_project = werk_xml.css('isProject').text == "1"
    end

    def project
      url_project = "http://www.wegwerkmeldingen.nl/GetWegObjecten.php?ID=&van=2000-1-1&tot=2099-1-1&directnaarID_andor=1&directnaarID=#{@projectnummer}&layout=6&toeval=#{Random.rand}"
      xml = Nokogiri::XML(open(url_project)) do |config|
        config.noblanks.noent.nonet
      end
      return Werk.new(xml)
    end

    def deepen!
      werk_xml = Nokogiri::XML(open(deep_url)) do |config|
        config.noblanks.noent.nonet
      end
      # Now we have some more info
      @openbaar = werk_xml.css('Openbaar').text == "1"
      @xRD = werk_xml.css('xRD').text
      @yRD = werk_xml.css('yRD').text
      @tekst = uncode(werk_xml.css('Tekst').text)
      @plaatsnaam = uncode(werk_xml.css('plaatsnaam').text)
      @naam = uncode(werk_xml.css('Naam').text)
      @dagvandeweek = uncode(werk_xml.css('DagvdWeek').text)
    end


    private

    def uncode(text)
      coder = HTMLEntities.new
      coder.decode(URI.unescape(text))
    end

    def deep_url
      "http://www.wegwerkmeldingen.nl/GetWegObjecten.php?ID=&van=2000-1-1&tot=2099-1-1&directnaarID_andor=1&directnaarID=#{@objectnummer}&layout=6&toeval=#{Random.rand}"
    end

    def degrees2meters lon, lat
      x = lon * 20037508.34 / 180
      y = Math.log(Math.tan((90 + lat) * Math::PI / 360)) / (Math::PI / 180);
      y = y * 20037508.34 / 180
      return [x, y]
    end

    def meters2degrees x, y
      radius = 6378137.0;
      lon = (180 / Math::PI) * (x / radius);
      lat = (360 / Math::PI) * (Math.atan(Math.exp(y / radius)) - (Math::PI / 4));
      return [lon, lat]
    end
  end
end