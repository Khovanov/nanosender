class Api::V1::MessagesController < Api::V1::BaseController

  def single
    message = Message.new(message_params.to_h.symbolize_keys)
    if message.valid?
      job_id = message.send_to_job
      render json: { result: { code: 201, message: "Created: Message send to queue with Job ID: #{job_id}"} }, status: :created
    else
      # errors = message.errors.full_messages.uniq.join(", ")
      errors = message.errors.full_messages.join(", ")
      render json: { error: { code: 400, message: "Bad Request: #{errors}"} }, status: :bad_request
    end
  end

  def batch
    user_ids = params[:message][:user_id].split(',').uniq
    messengers = params[:message][:messenger].split(',').uniq
    body = message_params[:body]

    messages = create_messages(user_ids, messengers, body)
    if messages.map(&:valid?).include?(false)
      errors = messages.map(&:errors).map(&:full_messages).flatten.uniq.join(", ")
      render json: { error: { code: 400, message: "Bad Request: #{errors}"} }, status: :bad_request
    else
      job_ids = messages.map(&:send_to_job).join(", ")
      render json: { result: { code: 201, message: "Created: All messages send to queue with Job ID: #{job_ids}"} }, status: :created
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

  # API DOC for Swagger
  swagger_path '/messages/single' do
    operation :post do
      key :description, 'Create message'
      key :operationId, 'single'
      key :produces, [
        'application/json',
        'text/html',
      ]
      key :tags, [
        'message'
      ]

      parameter do
        key :name, :access_token
        key :in, :query
        key :description, 'Access token: 12345'
        key :required, true
        key :type, :string
      end

      parameter do
        key :name, :'message[user_id]'
        key :in, :query
        key :description, 'User_id: 1, 2, 3, 4'
        key :required, true
        key :type, :integer
        key :format, :int32
      end

      parameter do
        key :name, :'message[messenger]'
        key :in, :query
        key :description, 'Messenger: Viber, Telegram, WhatsApp'
        key :required, true
        key :type, :string
      end

      parameter do
        key :name, :'message[body]'
        key :in, :query
        key :description, 'Body: some text less than 100 characters'
        key :required, true
        key :type, :string
      end

      response 201 do
        key :description, 'created'
        schema do
          key :'$ref', :Message
        end
      end
      response 401 do
        key :description, 'unauthorized'
        schema do
          key :'$ref', :ErrorModel
        end
      end
      response 400 do
        key :description, 'bad request'
        schema do
          key :'$ref', :ErrorModel
        end
      end
    end
  end

  swagger_path '/messages/batch' do
    operation :post do
      key :description, 'Create message'
      key :operationId, 'batch'
      key :produces, [
        'application/json',
        'text/html',
      ]
      key :tags, [
        'message'
      ]

      parameter do
        key :name, :access_token
        key :in, :query
        key :description, 'Access token: 12345'
        key :required, true
        key :type, :string
      end

      parameter do
        key :name, :'message[user_id]'
        key :in, :query
        key :description, 'User_id: 1, 2, 3, 4'
        key :required, true
        key :type, :array
        items do
          key :type, :integer
          key :format, :int32
        end
        key :collectionFormat, :csv
      end

      parameter do
        key :name, :'message[messenger]'
        key :in, :query
        key :description, 'Messenger: Viber, Telegram, WhatsApp'
        key :required, true
        key :type, :array
        items do
          key :type, :string
        end
        key :collectionFormat, :csv
      end

      parameter do
        key :name, :'message[body]'
        key :in, :query
        key :description, 'Body: some text less than 100 characters'
        key :required, true
        key :type, :string
      end

      response 201 do
        key :description, 'created'
        schema do
          key :'$ref', :Message
        end
      end
      response 401 do
        key :description, 'unauthorized'
        schema do
          key :'$ref', :ErrorModel
        end
      end
      response 400 do
        key :description, 'bad request'
        schema do
          key :'$ref', :ErrorModel
        end
      end
    end
  end

end
