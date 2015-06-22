require "nokogiri"
require "open-uri"
url_objects = "http://www.wegwerkmeldingen.nl/GetWegObjecten.php?ID=&regio=9&layout=5&alleenRegio=0&toeval=#{Random.rand}"
object_url = "http://www.wegwerkmeldingen.nl/GetWegObjecten.php?ID=&van=2000-1-1&tot=2099-1-1&directnaarID_andor=1&directnaarID=1328847&layout=6&toeval=#{Random.rand}"

puts "Getting the road works, hold on"
xml_doc  = Nokogiri::XML(open(url_objects))
puts xml_doc.inspect