class TasksController < ApplicationController
  before_action :set_workspace
  before_action :set_task, only: [:show, :update, :destroy]
  before_action :authorize_workspace_member

  # GET /workspaces/:workspace_id/tasks
  def index
    @tasks = @workspace.tasks

    # Filter by category if category_id is provided
    if params[:category_id].present?
      @tasks = @tasks.where(category_id: params[:category_id])
    end

    # Sort by a specified attribute if sort_by is provided
    if params[:sort_by].present?
      @tasks = @tasks.order(params[:sort_by])
    end

    # Paginate the tasks
    @tasks = @tasks.page(params[:page]).per(params[:limit] || 10)

    render json: @tasks
  end

  # GET /workspaces/:workspace_id/tasks/:id
  def show
    render json: @task
  end

  # POST /workspaces/:workspace_id/tasks
  def create
    @task = @workspace.tasks.new(task_params)
    if @task.save
      render json: {message: "Task created sucessfully", task: @task}, status: :created
    else
      render_error(:unprocessable_entity, @task.errors.full_messages)
    end
  end

  # PUT /workspaces/:workspace_id/tasks/:id
  def update
    if @task.update(task_params)
      render json: {message: "Task updated successfully",task: @task}, status: :ok
    else
      render_error(:unprocessable_entity, @task.errors.full_messages)
    end
  end

  # DELETE /workspaces/:workspace_id/tasks/:id
  def destroy
    if @task.destroy
      head :no_content
    else
      render_error(:unprocessable_entity, @task.errors.full_messages)
    end
  end

  private

  def set_workspace
    @workspace = Workspace.find(params[:workspace_id])
  end

  def set_task
    @task = @workspace.tasks.find(params[:id])
  end

  def authorize_workspace_member
    unless @workspace.users.include?(current_user)
      render json: { errors: 'Not authorized' }, status: :forbidden
    end
  end

  def task_params
    params.require(:task).permit(:title, :description, :due_date, :notify_before, :priority, :category_id, :status, :assignee_id)
  end
end 