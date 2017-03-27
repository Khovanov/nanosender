class ApidocsController < ApplicationController
  include Swagger::Blocks

  swagger_root do
    key :swagger, '2.0'
    info do
      key :version, '1.0.0'
      key :title, 'Swagger Nanosender'
      key :description, 'A sample API that uses a for send messages to users ' \
                        'demonstrate features in the swagger-2.0 specification'
      # key :termsOfService, 'http://helloreverb.com/terms/'
      # contact do
      #   key :name, 'API Team'
      # end
      # license do
      #   key :name, 'MIT'
      # end
    end
    tag do
      key :name, 'nano'
      key :description, 'Message operations'
      externalDocs do
        key :description, 'Find more info here'
        key :url, 'https://swagger.io'
      end
    end
    # key :host, 'https://nanosender.herokuapp.com/'
    # key :host, '127.0.0.1:3000'
    key :host, 'nanosender.herokuapp.com'
    key :basePath, '/api/v1'
    key :consumes, ['application/json']
    key :produces, ['application/json']
  end

  # A list of all classes that have swagger_* declarations.
  SWAGGERED_CLASSES = [
    Api::V1::UsersController,
    Api::V1::MessagesController,
    User,
    Message,
    ErrorModel,
    self,
  ].freeze

  def index
    render json: Swagger::Blocks.build_root_json(SWAGGERED_CLASSES)
  end
end
