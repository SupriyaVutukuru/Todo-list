class WorkspacesController < ApplicationController
  before_action :authorize_request
  before_action :set_workspace, only: [:add_member]

  def create
    @workspace = current_user.workspaces.new(workspace_params)
    if @workspace.save
      render json: @workspace, status: :created
    else
      render_error(:unprocessable_entity, @workspace.errors.full_messages)
    end
  end

  def add_member
    user = User.find_by(username: params[:username])
    if user && @workspace.users.exclude?(user)
      @workspace.users << user
      render json: { message: 'User added successfully' }, status: :ok
    else
      render json: { errors: 'User not found or already a member' }, status: :unprocessable_entity
    end
  end

  private

  def set_workspace
    @workspace = Workspace.find_by(id: params[:id])
    render json: { errors: 'Workspace not found' }, status: :not_found unless @workspace
  end

  def workspace_params
    params.require(:workspace).permit(:name, :description)
  end
end 