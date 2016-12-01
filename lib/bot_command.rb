require 'telegram/bot'
require 'marky_markov'

module BotCommand
  class Base
    attr_reader :user, :message, :api

    def initialize(user, message)
      @user = user
      @message = message
      token = ENV['token']
      @api = ::Telegram::Bot::Api.new(token)
    end

    def should_start?
      raise NotImplementedError
    end

    def start
      raise NotImplementedError
    end

    protected

    def send_message(text, options={})
      @api.call('sendMessage', chat_id: @user.telegram_id, text: text)
    end

    def text
      @message[:message][:text]
    end

    def from
      @message[:message][:from]
    end
  end

  class Help < Base
    def should_start?
      text =~ /\A\/help/
    end

    def start
      #binding.pry
      send_message('All avialible commands:')
      BotMessageDispatcher::COMMANDS.keys.each do |value|
        send_message("/#{value}")
      end
      user.reset_next_bot_command
    end
  end


  class Demo < Base
    def should_start?
      text =~ /\A\/demo/
    end

    def start
      url = URI.parse("https://api.opendota.com/api/players/157716564/wordcloud")
      words = JSON.parse(Net::HTTP.get(url))
      @api.call('sendSticker', chat_id: @user.telegram_id, sticker: 'BQADAgADFQADve_JBtWyUnrdC0GdAg')
      send_message(words["my_word_counts"].keys.sample)
    end
  end

   class Analytics < Base
    def should_start?
      text =~ /\A\/anal/
    end

    def start
      #binding.pry
      url = URI.parse("https://api.opendota.com/api/players/157716564/wordcloud")
      words = JSON.parse(Net::HTTP.get(url))
      #@api.call('sendSticker', chat_id: @user.telegram_id, sticker: 'BQADAgADFQADve_JBtWyUnrdC0GdAg')
      #binding.pry
      string = ""
      words["my_word_counts"].keys.each do |word|
        string << " " << word
      end
      markov = MarkyMarkov::TemporaryDictionary.new
      markov.parse_string string
      send_message("In-game Analytics")
      send_message(markov.generate_n_words 10)
    end
  end

  class DailyStat < Base
    def should_start?
      text =~ /\A\/daily_stat/
    end

    def start
      #binding.pry
      unrank_url = URI.parse("https://api.opendota.com/api/players/157716564/wl?lobby_type=0&date=1")
      rank_url = URI.parse("https://api.opendota.com/api/players/157716564/wl?lobby_type=7&date=1")
      unrank = JSON.parse(Net::HTTP.get(unrank_url))
      rank = JSON.parse(Net::HTTP.get(rank_url))
      send_message("потных вин: #{rank['win']}, луз: #{rank['lose']}")
      send_message("легких вин: #{unrank['win']}, луз: #{unrank['lose']}")
    end
  end

  class Demo < Base
    def should_start?
      text =~ /\A\/demo/
    end

    def start
      #binding.pry
      url = URI.parse("https://api.opendota.com/api/players/157716564/wordcloud")
      words = JSON.parse(Net::HTTP.get(url))
      @api.call('sendSticker', chat_id: @user.telegram_id, sticker: 'BQADAgADFQADve_JBtWyUnrdC0GdAg')
      send_message(words["my_word_counts"].keys.sample)
    end
  end

  class NuffSaid < Base
    def should_start?
      text =~ /\A\/nuff_said/
    end

    def start
      #binding.pry
      url = URI.parse("https://api.opendota.com/api/players/212838883/wordcloud")
      words = JSON.parse(Net::HTTP.get(url))
      url = URI.parse("https://api.opendota.com/api/players/98977895/wordcloud")
      words.merge(JSON.parse(Net::HTTP.get(url)))
      string = ""
      words["my_word_counts"].keys.each do |word|
        string << " " << word
      end
      markov = MarkyMarkov::TemporaryDictionary.new
      markov.parse_string string
      @api.call('sendSticker', chat_id: @user.telegram_id, sticker: 'BQADAgADTgADgZGXCSQKssDR8ic0Ag')
      send_message(markov.generate_n_words rand(1...5))
      send_message(markov.generate_n_words rand(1...5))
      #user.reset_next_bot_command
      #user.set_next_bot_command('BotCommand::Born')
    end
  end

  class Undefined < Base
    def start
      send_message('It is not time yet')
      send_message('Enter /help for list of available commands')
    end
  end
end
