class Api::V1::UsersController < Api::V1::BaseController

  def index
    # render json: User.all, root: "users", adapter: :json
    respond_with User.all, root: "users", adapter: :json
  end

  # API DOC for Swagger
  swagger_path '/users' do
    operation :get do
      key :description, 'Returns all users'
      key :operationId, 'findUsers'
      key :produces, [
        'application/json',
        'text/html',
      ]
      key :tags, [
        'user'
      ]

      parameter do
        key :name, :access_token
        key :in, :query
        key :description, 'Access token'
        key :required, true
        key :type, :string
      end

      response 200 do
        key :description, 'user response'
        schema do
          key :type, :array
          items do
            key :'$ref', :User
          end
        end
      end
      response 401 do
        key :description, 'unauthorized'
        schema do
          key :'$ref', :ErrorModel
        end
      end
    end
  end

end
