class ApplicationController < ActionController::API
  before_action :authorize_request

  attr_reader :current_user

  def not_found
    render json: { error: 'not_found' }
  end

  def render_error(status, errors)
    render json: { errors: errors }, status: status
  end

  private

  def authorize_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    begin
      @decoded = JsonWebToken.decode(header)
      @current_user = User.find(@decoded[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end
end