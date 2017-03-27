class User < ApplicationRecord
  include Swagger::Blocks

  swagger_schema :User do
    key :required, [:id, :name]
    property :id do
      key :type, :integer
      key :format, :int64
    end
    property :name do
      key :type, :string
    end
    property :created_at do
      key :type, :string
    end
    property :updated_at do
      key :type, :string
    end
  end

end
