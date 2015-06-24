require "werkzaamheden/version"
require "nokogiri"
require "open-uri"
require "htmlentities"
require "werkzaamheden/werk"

module Werkzaamheden
  class Core
    def self.url_objects
      "http://www.wegwerkmeldingen.nl/GetWegObjecten.php?ID=&regio=9&layout=5&alleenRegio=0&toeval=#{Random.rand}"
    end
    def self.xml_doc
      @xml_document ||= Nokogiri::XML(open(url_objects)) do |config|
        config.noblanks.noent.nonet
      end
    end

    # def self.all_werken
    #   xml_doc.xpath('//Werk')
    # end

    def self.werken
      #xml_doc.xpath('//Werk[./Typ[text()>1]]')
      @werken ||= xml_doc.xpath('//Werk').map { |e| Werkzaamheden::Werk.new(e) }
    end
  end
end
