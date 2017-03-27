class Message
  MAX_TEXT_SIZE = 100

  include Swagger::Blocks

  swagger_schema :Message do
    key :required, [:result]
    property :result do
      property :code do
        key :type, :integer
        key :format, :int32
      end
      property :message do
        key :type, :string
      end
    end
  end

  attr_reader :user_id, :messenger, :body, :error

  def initialize(user_id:, messenger:, body:)
    @user_id = user_id
    @messenger = messenger
    @body = body
    @error = nil
  end

  def send
    job_params = { wait_until: Date.today.end_of_day, queue: messenger.downcase.to_sym }
    job = SendMessageJob.set(job_params).perform_later(user_id: user_id, messenger: messenger, body: body)
    job_id = job.provider_job_id
    Rails.logger.debug "Task with Job ID: #{job_id} for send message add to workers queue"
    job_id
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
