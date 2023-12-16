require 'rails_helper'

RSpec.describe 'Authorizations', type: :request do
  let!(:client) { create(:client_application) }
  let!(:state) { Faker::Alphanumeric.alpha(number: 25) }
  let!(:valid_query_params) { client.attributes }
  let!(:invalid_query_params) do
    {
      'client_id' => 'unregistered client id',
      'redirect_uris' => 'http://unknownclient.com/callback'
    }
  end
  let!(:headers) do
    {
      'Content-Type': 'application/x-www-form-urlencoded'
    }
  end

  describe 'GET /authorize' do
    context 'authentication of resource owner'
    context 'test support for only authorization code grant type' do
      before do
        get "/authorize",
        params: {
          client_id: valid_query_params['client_id'],
          response_type: 'token',
          redirect_uri: valid_query_params['redirect_uris'][0],
          state: state,
          scope: valid_query_params['scopes']
        },
        headers:
      end

      it 'should redirect to error_url' do
        expect(response).to redirect_to error_path(
          error: 'invalid_request',
          error_description: 'Unsupported response type'
        )
      end
    end

    context 'when server receives redirect from client' do
      context 'if client is recognized by authorization server' do
        before do
          get "/authorize",
          params: {
            client_id: valid_query_params['client_id'],
            response_type: 'code',
            redirect_uri: valid_query_params['redirect_uris'][0],
            state: state,
            scope: valid_query_params['scopes']
          },
          headers:
        end
        let!(:client_request) { request }

        it 'should render authorize template' do
          expect(response).to render_template(:authorize)
        end

        it 'should respond with status of 200' do
          expect(response).to have_http_status(:ok)
        end

        it 'renders state params equal to what client provided in request if present' do
          expect(assigns[:state]).to eq(client_request['state'])
        end

        
        context 'redirect_uri' do
          it 'renders redirect_uri as supplied by client in request to this endpoint' do
            expect(assigns[:redirect_uri]).to eq(client_request['redirect_uri'])
          end

          it 'should redirect to error_path if wrong redirect_uri is provided' do
            get "/authorize",
              params: {
              client_id: valid_query_params['client_id'],
              response_type: 'code',
              redirect_uri: invalid_query_params['redirect_uris'][0],
              state: state,
              scope: valid_query_params['scopes']
            },
            headers: headers

            expect(response).to redirect_to error_path(
              error: 'invalid_request',
              error_description: 'client is not registered or provided an invalid redirect uri'
            )
          end
        end

        context 'scopes' do
          it 'should render scope if scope is supplied by client' do
            expect(assigns[:scopes]).to eq(client_request['scope'])
          end

          it 'should render scope as registered by client in db if not passed in client request' do
            get "/authorize",
            params: {
              client_id: valid_query_params['client_id'],
              response_type: 'code',
              redirect_uri: valid_query_params['redirect_uris'][0],
              state: state
            },
            headers: headers

            expect(assigns[:scopes]).to eq(client.minimum_scope_set)
          end
        end

        context 'when wrong redirect uri is provided by client' do
          it 'should return error without redirecting to provided redirect uri'
        end
      end

      context 'if client is not recognized by authorization server' do
        before do
          get "/authorize",
          params: {
              client_id: invalid_query_params['client_id'],
              response_type: 'code',
              redirect_uri: invalid_query_params['redirect_uris'][0],
              state: state
            },
            headers: headers
        end

        it 'should redirect to error url with query params containing error code and description' do
          expect(response).to redirect_to error_path(
            error: 'invalid_request',
            error_description: 'client is not registered or provided an invalid redirect uri'
          )
        end
      end

      context 'check if response_type is supported'
    end
  end

  describe 'POST /token' do
    context 'authorized clients' do
      # successful authentication of client via HTTP Basic Authentication scheme
      context 'check if grant_type is supported'
      context 'check if authorization code is valid' do
         # context 'authorization code' do
        #   let!(:token) { client.generate_authorization_code }
        #   let!(:hmac_secret) { Rails.application.secret_key_base }

        #   it 'should be valid before 10 minutes' do
        #     expect do
        #       JWT.decode token, hmac_secret, true, { algorithm: 'HS256' }
        #     end.to_not raise_error(JWT::ExpiredSignature)
        #   end

        #   it 'should be invalid after 10 minutes' do
        #     future_time = (Time.now + 11.minutes).to_i

        #     Timecop.freeze(future_time) do
        #       expect do
        #         JWT.decode token, hmac_secret, true, { algorithm: 'HS256' }
        #       end.to raise_error(JWT::ExpiredSignature)
        #     end
        #   end
        # end
        it 'if code was issued by server'
        it 'if code is expired'
        it 'if code was used more than once'
        it 'if not valid, should respond with appropriate error'
        it 'if valid, should issue both valid access and refresh tokensf'
      end

      context 'validate presence of redirect uri' do
        it 'if present in previous authorize request, require it or responde with invalid request error'
        it 'if absent, fallback on registered redirect uris in database'
      end
    end

    context 'unauthorized or unknown client' do
      # unsuccessful authentication
      it 'should respond with appropriate error response'
    end
  end
end
