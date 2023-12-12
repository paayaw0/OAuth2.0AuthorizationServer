require 'rails_helper'

RSpec.describe 'Authorizations', type: :request do
  let!(:client) { create(:client_application) }
  let!(:state) { Faker::Alphanumeric.alpha(number: 25) }
  let!(:valid_query_params) { client.attributes }
  let!(:invalid_query_params) do
    {
      'name' => 'unregistered client',
      'client_id' => 'unregistered client id',
      'client_secret' => 'unregistered client secret',
      'authorization_code' => 'unregistered authorization code',
      'access_token' => 'invalide access code',
      'refresh_token' => 'invalid refresh code',
      'redirect_uris' => 'http://unknownclient.com/callback'
    }
  end

  describe 'GET /authorize' do
    context 'when server receives redirect from client' do
      context 'if client is recognized by authorization server' do
        before do
          get "/authorize?client_id=#{valid_query_params['client_id']}&response_type=code&redirect_uri=#{valid_query_params['redirect_uris'][0]}&state=#{state}"
        end

        it 'should render authorize template' do
          expect(response).to render_template(:authorize)
        end

        it 'should respond with status of 200' do
          expect(response).to have_http_status(:ok)
        end

        context 'authorization code' do
          it 'should be valid before 10 minutes' do
            expect do
              JWT.decode token, hmac_secret, true, { algorithm: 'HS256' }
            end.to_not raise_error(JWT::ExpiredSignature)
          end

          it 'should be invalid after 10 minutes' do
            future_time = (Time.now + 11.minutes).to_i
            token = client.generate_authorization_code
            hmac_secret = Rails.application.secret_key_base

            Timecop.freeze(future_time) do
              expect do
                JWT.decode token, hmac_secret, true, { algorithm: 'HS256' }
              end.to raise_error(JWT::ExpiredSignature)
            end
          end
        end
      end
    end
  end
end
