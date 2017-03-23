class SendMessageJob < ApplicationJob
  attr_accessor :messenger

  queue_as :default

  rescue_from(StandardError) do |exception|
    notify_failed_job(exception)
  end

  def perform( user_id:, messenger:, body: )
    @messenger = messenger
    messenger_class.new(user_id: user_id, body: body).call
    Rails.logger.debug "Send message: #{body} , to: #{user_id}, through: #{messenger}"
  end

  private

  def notify_failed_job(exception)
    Rails.logger.debug "Messenger: #{messenger} Exception: #{exception}"
    NotificationMailer.job_failed(messenger, exception.to_s).deliver_later
  end

  def messenger_class
    "#{messenger.downcase.camelize}Messenger".constantize
  end
end
