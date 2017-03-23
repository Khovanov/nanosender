class BaseMessenger
  MESSENGERS = %w{Viber Telegram WhatsApp}

  attr_reader :user, :body

  def initialize(user_id:, body:)
    @user = User.find(user_id)
    @body = body
  end

  def self.valid?(messenger)
    messenger.present? && MESSENGERS.include?(messenger)
  end
end
