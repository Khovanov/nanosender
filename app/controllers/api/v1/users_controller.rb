class Api::V1::UsersController < Api::V1::BaseController

  def index
    # render json: User.all, root: "users", adapter: :json
    respond_with User.all, root: "users", adapter: :json
  end
end
