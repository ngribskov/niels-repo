require 'socket'
require 'nokogiri'
require 'open-uri'
require 'pry'
# require 'logger'


TWITCH_HOST = 'irc.twitch.tv'
TWITCH_PORT = 6667


class TwitchBot

  def initialize
    @nickname = "EQAssistBot"
    @password = "oauth:zvike8ag8qccmmh5hlrtohef8skhx2"
    @channel = "paparobshow"
    @socket = TCPSocket.open(TWITCH_HOST, TWITCH_PORT)
    @discord = "https://discord.gg/M97e85b"
    write_to_system "PASS #{@password}"
    write_to_system "NICK #{@nickname}"
    write_to_system "USER #{@nickname} 0 * #{@nickname}"
    write_to_system "JOIN ##{@channel}"
  end

  def titleize(str)
      str.capitalize!  # capitalize the first word in case it is part of the no words array
      words_no_cap = ["and", "or", "of", "the", "over", "to", "the", "a", "but"]
      phrase = str.split(" ").map {|word|
          if words_no_cap.include?(word)
              word
          else
              word.capitalize
          end
      }.join(" ") # I replaced the "end" in "end.join(" ") with "}" because it wasn't working in Ruby 2.1.1
    phrase  # returns the phrase with all the excluded words
  end

  def write_to_system(message)
    @socket.puts message
  end

  def write_to_chat(message)
    write_to_system "PRIVMSG ##{@channel} :#{message}"
  end

  def run
    # @logger = Logger.new('faileditems.log')
    ping_count = 0
    until @socket.eof? do
      message = @socket.gets
      puts message

      # if message.match(/^PING :(.*)$/)
      #   write_to_system "PONG #{$~[1]}"
      #   ping_count += 1
      #   puts "Ping count is #{ping_count}"
      #   case ping_count
      #   when 1
      #     write_to_chat "Want to know what your loot is worth? Try !auction <Item Name>"
      #   when 4
      #     write_to_chat "Use !discord to get PapaRob's Discord server address."
      #   when 7
      #     ping_count = 0
      #     write_to_chat "Looking for an item? Try me out! Use !item <Item Name>"
      #   end
      #   next
      # end

      if message.match(/PRIVMSG ##{@channel} :(.*)$/)
        content = $~[1]
        username = message.match(/@(.*).tmi.twitch.tv/)[1]

        if content.include? "!item"
          request = content.gsub("!item ","").chomp
          response = fetch_item_info(request)
          write_to_chat("#{response[:item]}")
        end

        if content.include? "!auction"
          request = content.gsub("!auction ","").chomp
          fetch_price_info(request)
        end

        if content.include? "!discord"
          write_to_chat("Join PapaRob in Discord at #{@discord}")
        end

        if content.include? "!eqassist"
          write_to_chat("Want help finding an item? Use !item <item name>. Wonder what your loot is worth? Use !auction <item name>")
        end

        if content.include? "!commands"
          write_to_chat("Available commands: !item, !auction, and !discord")
        end
      end
    end
  end

  def fetch_item_info(item_name)
    item_info = []

    item_prepared = titleize(item_name)
    query = 'http://wiki.project1999.com/' + item_prepared.gsub(" ","_")
    begin
    doc = Nokogiri::HTML(open(query))

    item_info = item_prepared + " " + doc.xpath('//div[@class = "itemdata"]/p')[0].text.gsub("\n"," ")
    rescue
      item_info = "Failed to find item, please check your spelling!"
      # @logger.info ("Failed Item: #{item_prepared}")
    end
    # puts item_info
    return {url: query, item: fit_chat_size(item_info)}
  end

  def fetch_price_info(item_name)
    query = 'http://agnprice.com/?name=' + item_name.gsub(" ","+")
    begin
      doc = Nokogiri::HTML(open(query))
      response =  { 'ten_day_sell_avg' => doc.xpath("//table[@style='border-collapse:collapse;']/tr[@bgcolor='#A9D0F5']/td")[1].text,
                    'ten_day_buy_avg' => doc.xpath("//table[@style='border-collapse:collapse;']/tr[@bgcolor='#A9D0F5']/td")[3].text,
                    'found_name' => doc.xpath("//div[@class='list_display']/p").text,
                    'krono_sell_price' => doc.xpath("//table[@id = 'maintable']/tr")[2].children[3].children.text,
                    'krono_sell_time' => doc.xpath("//table[@id = 'maintable']/tr")[2].children[1].children.text}
      if response['ten_day_sell_avg'] == '0' && response['krono_sell_price'].length == 0
          write_to_chat("There is no sell data available for this item.")
      elsif response['ten_day_sell_avg'] == '0'
        write_to_chat("#{response["found_name"]} was last auctioned for #{response['krono_sell_price']} #{response['krono_sell_time']}. Prices available through Agnarr Auctions Price Check at agnprice.com")
      else
        write_to_chat("#{response["found_name"]} 10 day average sell price: #{response["ten_day_sell_avg"]} // 10 day average buy price: #{response["ten_day_buy_avg"]}. Prices available through Agnarr Auctions Price Check at agnprice.com")
      end
    rescue
      write_to_chat("Your price lookup failed, please check your spelling or provide a more accurate item name.")
      # @logger.info("Failed Auction: #{item_name}")
    end
  end

  def quit
    write_to_chat "EQAssistBot is closing. Goodbye!"
    write_to_system "PART ##{@channel}"
    write_to_system "QUIT"
    # @logger.info("End of Session")
    @conn.close
  end

  def fit_chat_size(input_string)
    max_chars = 400
    if input_string.length > max_chars
      output_string = "%3.#{max_chars - 3}s" % input_string + '...'
      return output_string
    else
      return input_string
    end
  end

end

bot = TwitchBot.new

trap("INT") { bot.quit }
bot.run

# This bot was created by Niels Gribskov, Twitch.tv user ngribsko
