class Api::V1::MessagesController < Api::V1::BaseController

  def single
    message = Message.new(message_params.to_h.symbolize_keys)
    if message.valid?
      job_id = message.send
      render json: { result: { code: 201, text: "Created: Message send to queue with Job ID: #{job_id}"} }, status: :created
    else
      render json: { error: { code: 400, text: "Bad Request: #{message.error}"} }, status: :bad_request
    end
  end

  def batch
    user_ids = params[:message][:user_id].uniq
    messengers = params[:message][:messenger].uniq
    body = message_params[:body]

    messages = create_messages(user_ids, messengers, body)
    if messages.map(&:valid?).include?(false)
      errors = messages.map(&:error).uniq.join(", ")
      render json: { error: { code: 400, text: "Bad Request: #{errors}"} }, status: :bad_request
    else
      job_ids = messages.map(&:send).join(", ")
      render json: { result: { code: 201, text: "Created: All messages send to queue with Job ID: #{job_ids}"} }, status: :created
    end
  end

  private

  def create_messages(user_ids, messengers, body)
    messages = []
    user_ids.each do |user_id|
      messengers.each do |messenger|
        messages.push Message.new(user_id: user_id, messenger: messenger, body: body)
      end
    end
    messages
  end

  def message_params
    params.require(:message).permit(:user_id, :messenger, :body)
  end
end
