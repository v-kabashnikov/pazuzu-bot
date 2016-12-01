require 'telegram/bot'
include BotCommand
require 'bot_message_dispatcher'

class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def callback
    # binding.pry
    # @api = ::Telegram::Bot::Api.new(ENV['token'])
    # #@api.send_message(chat_id:  params[:message][:chat][:id], text: "Hello")
    # question = 'London is a capital of which country?'
    # # See more: https://core.telegram.org/bots/api#replykeyboardmarkup
    # answers =
    #   Telegram::Bot::Types::ReplyKeyboardMarkup
    #   .new(keyboard: [%w(A B), %w(C D)], one_time_keyboard: true)
    # @api.send_message(chat_id: params[:message][:chat][:id], text: question, reply_markup: answers)
    dispatcher.new(webhook, user).process
  end

  def webhook
    params['webhook']
  end

  def dispatcher
    ::BotMessageDispatcher
  end

  def from
    message ||= webhook[:edited_message] || webhook[:message]
    message[:from]
  end

  def user
    @user ||= User.find_by(telegram_id: from[:id]) || register_user
  end

  def register_user
    @user = User.find_or_initialize_by(telegram_id: from[:id])
    @user.update_attributes!(first_name: from[:first_name], last_name: from[:last_name])
    @user
  end
end
