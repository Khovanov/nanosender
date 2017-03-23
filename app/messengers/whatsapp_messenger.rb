class WhatsappMessenger < BaseMessenger

  def call
    # WhatsApp messenger engine
    sleep(3)
    Rails.logger.debug "[WhatsApp] Hi #{user.name}, we have new message for you: #{body}"
  end
end
