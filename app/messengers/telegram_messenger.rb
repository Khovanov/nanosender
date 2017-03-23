class TelegramMessenger < BaseMessenger

  def call
    # raise "Some wrong in Telegram messenger :("
    # Telegram messenger engine
    sleep(3)
    Rails.logger.debug "[Telegram] Hi #{user.name}, we have new message for you: #{body}"
  end
end
