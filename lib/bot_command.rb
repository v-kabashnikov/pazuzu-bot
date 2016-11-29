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

  # class Start < Base
  #   def should_start?
  #     text =~ /\A\/start/
  #   end

  #   def start
  #     send_message('Раз')
  #     #user.reset_next_bot_command
  #     #user.set_next_bot_command('BotCommand::Born')
  #   end
  # end

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
      #user.set_next_bot_command('BotCommand::Born')
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
      #user.reset_next_bot_command
      #user.set_next_bot_command('BotCommand::Born')
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
      #user.reset_next_bot_command
      #user.set_next_bot_command('BotCommand::Born')
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
      #user.reset_next_bot_command
      #user.set_next_bot_command('BotCommand::Born')
    end
  end

  # class Born < Base
  #   def should_start?
  #     text =~ /\A\/born/
  #   end

  #   def start
  #     send_message("You have been just born! It’s time to learn some programming stuff. Type /accomplish_tutorial to start learning Rails from simple tutorial!")
  #     user.set_next_bot_command('BotCommand::AccomplishTutorial')
  #   end
  # end

  # class AccomplishTutorial < Base
  #   def should_start?
  #     text =~ /\A\/accomplish_tutorial/
  #   end

  #   def start
  #     send_message("It was hard, but it’s over! Models, controllers, views, wow, a lot stuff! Let’s practice now. What do you think about writing a Rails blog? Type /write_blog to continue.")
  #     user.set_next_bot_command('BotCommand::WriteBlog')
  #   end
  # end

  #  class WriteBlog < Base
  #   def should_start?
  #     text =~ /\A\/write_blog/
  #   end

  #   def start
  #     send_message('Hmm, looks cool! Seems like you really know Rails! A real rockstar!')
  #     user.reset_next_bot_command
  #   end
  # end

  class Undefined < Base
    def start
      send_message('It is not time yet')
      send_message('Enter /help for list of available commands')
    end
  end
end