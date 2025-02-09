require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  let!(:user) { create(:user) }
  let!(:workspace) { create(:workspace) }
  let!(:category) { create(:category) }
  let!(:task) { create(:task, workspace: workspace, assignee: user, category: category) }
  let(:token) { JsonWebToken.encode(user_id: user.id) }

  before do
    request.headers['Authorization'] = "Bearer #{token}"
    workspace.users << user  # Ensure the user is in the workspace
  end

  describe 'GET #index' do
    it 'returns all tasks for the workspace' do
      get :index, params: { workspace_id: workspace.id }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(1)
    end

    it 'filters tasks by category' do
      get :index, params: { workspace_id: workspace.id, category_id: category.id }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(1)
    end
  end

  describe 'GET #show' do
    it 'returns a task' do
      get :show, params: { workspace_id: workspace.id, id: task.id }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['id']).to eq(task.id)
    end

  end

  describe 'POST #create' do
    it 'creates a new task' do
      task_params = {
          title: 'New Task',
          description: 'Test task description',
          due_date: Date.today,
          priority: 'medium',
          status: 'pending',
          category_id: category.id,
          assignee_id: user.id
      }

      expect {
        post :create, params: { workspace_id: workspace.id, task: task_params }
      }.to change(Task, :count).by(1)

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)['message']).to eq('Task created sucessfully')
    end

    it 'returns unprocessable_entity for invalid task' do
      post :create, params: { workspace_id: workspace.id, task: { title: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'PUT #update' do
    it 'updates the task' do
      put :update, params: { workspace_id: workspace.id, id: task.id, task: { title: 'Updated Task' } }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['task']['title']).to eq('Updated Task')
    end


  end

  describe 'DELETE #destroy' do
    it 'deletes a task' do
      expect {
        delete :destroy, params: { workspace_id: workspace.id, id: task.id }
      }.to change(Task, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end

  end
end
