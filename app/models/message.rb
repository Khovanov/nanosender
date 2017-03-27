class Message
  include Mongoid::Document
  include Mongoid::Timestamps

  field :user_id, type: String
  field :messenger, type: String
  field :body, type: String
  field :deliver, type: Boolean
  index({ user_id: 1, messenger: 1, body: 1 }, { unique: true })

  validates :body, :user_id, :messenger, presence: true
  validates :body, length: { maximum: 100 }
  validate :user_id_must_be_valid,
    :messenger_must_be_valid,
    :message_must_be_uniqueness

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

  def send_to_job
    save
    job_params = { wait_until: Date.today.end_of_day, queue: self.messenger.downcase.to_sym }
    job = SendMessageJob.set(job_params).perform_later(user_id: self.user_id, messenger: self.messenger, body: self.body)
    job_id = job.provider_job_id
    Rails.logger.debug "Task with Job ID: #{job_id} for send message add to workers queue"
    job_id
  end

  private

  def user_id_must_be_valid
    errors.add(:user_id, "not valid") unless User.find_by(id: user_id)
  end

  def messenger_must_be_valid
    errors.add(:messenger, "not valid") unless BaseMessenger.valid?(messenger)
  end

  def message_must_be_uniqueness
    # errors.add(:body, "not uniqueness") if Message.find_by({ user_id: user_id, messenger: messenger, body: body })
    Message.find_by({ user_id: user_id, messenger: messenger, body: body })
  rescue Mongoid::Errors::DocumentNotFound
    # record uniqueness
  else
    errors.add(:body, "not uniqueness")
  end
end
