class ViberMessenger < BaseMessenger

  def call
    # Viber messenger engine
    sleep(3)
    Rails.logger.debug "[Viber] Hi #{user.name}, we have new message for you: #{body}"
  end
end
