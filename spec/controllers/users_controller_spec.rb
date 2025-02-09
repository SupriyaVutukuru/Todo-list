require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let!(:user) { create(:user) }
  let(:token) { JsonWebToken.encode(user_id: user.id) }

  before do
    request.headers['Authorization'] = "Bearer #{token}"
  end

  describe 'GET #index' do
    it 'returns a list of users' do
      get :index
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #show' do
    it 'returns user details' do
      get :show, params: { _username: user.username }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['username']).to eq(user.username)
    end

    it 'returns not found if user does not exist' do
      get :show, params: { _username: 'nonexistent_user' }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'POST #create' do
    let(:valid_params) do
      { user: { name: 'Test User', username: 'testuser', email: 'test@example.com',
                password: 'password', password_confirmation: 'password' } }
    end

    it 'creates a new user' do
      expect {
        post :create, params: valid_params
      }
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'PUT #update' do
    let(:update_params) { { user: { name: 'Updated Name' } } }


    it 'fails if user not found' do
      put :update, params: { _username: 'nonexistent_user', user: update_params[:user] }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the user' do
      expect {
        delete :destroy, params: { _username: user.username }
      }
      expect(response).to have_http_status(:ok)
    end

    it 'fails if user not found' do
      delete :destroy, params: { _username: 'nonexistent_user' }
      expect(response).to have_http_status(:not_found)
    end
  end

end
