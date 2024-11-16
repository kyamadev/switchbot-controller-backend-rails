class Api::DevicesController < ApplicationController
    before_action :authenticate_user!

    def index
        service = SwitchBotService.new(current_user)
        response = service.get_devices

        if response["error"].nil?
            render json: response, status: :ok
        else
            render json: { error: response["error"] }, status: :unprocessable_entity
        end
    end

    def control
        service = SwitchBotService.new(current_user)
        response = service.control_device(params[:id], params[:command])

        if response["error"].nil?
            render json: { message: "Command sent successfully" }, status: :ok
        else
            render json: { error: response["error"] }, status: :unprocessable_entity
        end
    end
end