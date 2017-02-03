require 'telegram/bot'
include BotCommand

class BotMessageDispatcher
  attr_reader :message, :user
  COMMANDS = {update: 'Update', demo: 'Demo', help: 'Help', daily_stat: 'DailyStat', anal: 'Analytics', nuff: 'NuffSaid', aaa: 'Aaa'}

  def initialize(message, user)
    @message = message
    @user = user
  end

  def process
    #binding.pry
    command = message.dig(:message, :text)
    if command
      command = message[:message][:text][1..-1]
      if COMMANDS.key?(command.to_sym)
        start_command = eval("BotCommand::#{COMMANDS[command.to_sym]}.new(user, message)")
        start_command.start
      else
        unknown_command
      end
    else
      unknown_command
    end



    # message[:message][:text]
    # if user.get_next_bot_command
    #   bot_command = user.get_next_bot_command.safe_constantize.new(user, message)

    #   if bot_command.should_start?
    #     bot_command.start
    #   else
    #     unknown_command
    #   end
    # else
    #   binding.pry
    #   command =
    #   if command == 'start'
    #     start_command = BotCommand::Start.new(user, message)
    #   end
    #   if start_command.should_start?
    #     start_command.start
    #   else
    #     #binding.pry
    #     unknown_command
    #   end
    # end
  end

  private

  def unknown_command
    BotCommand::Undefined.new(user, message).start
  end
end
