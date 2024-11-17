class Api::Auth::SessionsController < ApplicationController
    def create
      user = User.find_by(email: params[:email])
  
      if user&.valid_password?(params[:password])
        render json: { token: user.generate_jwt }, status: :ok
      else
        render json: { error: 'Invalid email or password' }, status: :unauthorized
      end
    end
  end