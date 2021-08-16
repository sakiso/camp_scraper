class Api::V1::ApplicationController < ActionController::API
  def index
    render json: { text: 'this is stub message!' }
  end
end
