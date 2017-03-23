class SendMessageJob < ApplicationJob
  attr_accessor :messenger

  queue_as :default

  def perform( user_id:, messenger:, body: )
    @messenger = messenger
    messenger_class.new(user_id: user_id, body: body).call
    Rails.logger.debug "Send message: #{body} , to: #{user_id}, through: #{messenger}"
  end

  private

  def messenger_class
    "#{messenger.downcase.camelize}Messenger".constantize
  end
end
