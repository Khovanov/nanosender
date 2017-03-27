class Api::V1::BaseController < ApplicationController
  include Swagger::Blocks
  protect_from_forgery with: :null_session
  before_action :token_authorize!
  respond_to :json

  private

  def token_authorize!
    return if params[:access_token] == Rails.application.secrets.access_token.to_s
    render json: { error: { code: 401, message: "Unauthorized: invalid access token"} }, status: :unauthorized
  end
end
