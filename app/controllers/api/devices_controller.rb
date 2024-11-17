require 'net/http'
require 'openssl'

class Api::DevicesController < ApplicationController
  before_action :authenticate_request!

  def index
    service = SwitchBotService.new(@current_user)
    response = service.get_devices

    if response['statusCode'] == 100
      render json: response['body'], status: :ok
    else
      render json: { error: response['message'], status_code: response['statusCode'] }, status: :unprocessable_entity
    end
  end

  def control
    service = SwitchBotService.new(@current_user)
    response = service.control_device(params[:id], params[:command])

    if response['statusCode'] == 100
      render json: { message: 'Command sent successfully' }, status: :ok
    else
      render json: { error: response['message'] }, status: :unprocessable_entity
    end
  end

  private

  def authenticate_request!
    token = request.headers['Authorization']
    decoded = JWT.decode(token, Rails.application.credentials.secret_key_base, true, { algorithm: 'HS256' }).first
    @current_user = User.find(decoded['user_id'])
  rescue JWT::ExpiredSignature
    render json: { error: 'Token has expired' }, status: :unauthorized
  rescue JWT::DecodeError
    render json: { error: 'Invalid token' }, status: :unauthorized
  end
end