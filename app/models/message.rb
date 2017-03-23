class Message
  MAX_TEXT_SIZE = 100

  attr_reader :user_id, :messenger, :body, :error

  def initialize(user_id:, messenger:, body:)
    @user_id = user_id
    @messenger = messenger
    @body = body
    @error = nil
  end

  def valid?
    user_valid? && messenger_valid? && body_valid?
  end

  private

  def user_valid?
    return true if User.find_by(id: user_id)
    @error = "Invalid user_id"
    false
  end

  def messenger_valid?
    return true if BaseMessenger.valid?(messenger)
    @error = "Invalid messenger"
    false
  end

  def body_valid?
    return true if body.present? && body.length <= MAX_TEXT_SIZE
    @error = "Invalid body"
    false
  end
end
