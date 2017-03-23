class Api::V1::MessagesController < Api::V1::BaseController

  def single
    message = Message.new(message_params)
    if message.valid?
      render json: { result: { code: 201, text: "Created: Message created"} }, status: :created
    else
      render json: { error: { code: 400, text: "Bad Request: #{message.error}"} }, status: :bad_request
    end
  end

  def batch
  end

  private
  
  def message_params
    params.require(:message).permit(:user_id, :messenger, :body).to_h.symbolize_keys
  end
end
