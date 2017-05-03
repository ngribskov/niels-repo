

require 'nokogiri'
require 'open-uri'
# find buylist prices
card = 'Ensnaring Bridge'
check_foil = true
query = ('http://www.mtgotraders.com/store/search.php?q='+card.downcase.gsub(/[ ]/,'+')+'&x=0&y=0')
doc = Nokogiri::HTML(open(query))
count = 0
price_array = []
doc.xpath('//tr').each do |node|

  entry = []
  cardname=node.xpath('//td[@class = "cardname"]')[count].text
  if cardname == card || ((card + ' *Foil*') == cardname && check_foil)
  entry << cardname
  entry << node.xpath('//td[@class = "set"]')[count].text
  entry << node.xpath('//td[@class = "buyprice"]')[count].text.gsub(/[\t\n]/,'').to_f
  price_array << entry
    count += 1
  end
end
puts price_array
