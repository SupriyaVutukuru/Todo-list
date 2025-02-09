class ApplicationController < ActionController::API
  before_action :authorize_request
  before_action :set_workspace

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
    token = header.split(' ').last if header
    begin
      decoded = JWT.decode(token, ENV['DEV_SECRET_KEY'])[0]
      @current_user = User.find(decoded['user_id'])
    rescue ActiveRecord::RecordNotFound, JWT::DecodeError
      render json: { errors: 'Invalid token' }, status: :unauthorized
    end
  end

  def set_workspace
    workspace_name = request.headers['x-workspace']
    @workspace = Workspace.find_by(name: workspace_name)
    render json: { error: 'Workspace not found' }, status: :not_found unless @workspace
  end

  def current_user
    @current_user
  end
end