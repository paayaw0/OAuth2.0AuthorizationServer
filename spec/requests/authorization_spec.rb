require 'rails_helper'

RSpec.describe 'Authorizations', type: :request do
  describe 'GET /authorize' do
    it 'returns http success' do
      get '/authorization/authorize'
      expect(response).to have_http_status(:success)
    end
  end
end
