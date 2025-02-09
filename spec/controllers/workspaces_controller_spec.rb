require 'rails_helper'

RSpec.describe WorkspacesController, type: :controller do
  let(:user) { create(:user) } # Create a user using FactoryBot
  let(:another_user) { create(:user) } # Another user to be added to the workspace
  let(:workspace) { create(:workspace, users: [user]) } # Create a workspace with the user

  before do
    allow(controller).to receive(:authorize_request).and_return(true)
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new workspace' do
        expect {
          post :create, params: { workspace: { name: 'Test Workspace', description: 'A test workspace' } }
        }.to change(Workspace, :count).by(1)

        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid attributes' do
      it 'returns an error if workspace creation fails' do
        expect {
          post :create, params: { workspace: { name: '' } }
        }.to_not change(Workspace, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['errors']).to include("Name can't be blank")
      end
    end
  end

  describe 'POST #add_member' do
    context 'when user does not exist' do
      it 'returns an error' do
        post :add_member, params: { id: workspace.id, username: 'nonexistent_user' }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['errors']).to eq('User not found or already a member')
      end
    end

  end
end
