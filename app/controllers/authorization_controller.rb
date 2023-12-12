class AuthorizationController < ApplicationController
  def authorize
    client_application = ClientApplication.find_by(client_id: params['client_id'])
    redirect_uri = params['redirect_uri']

    if client_application&.redirect_uris&.include?(redirect_uri)
      state = params['state']
      query_params = "?authorization_code=#{client_application.authorization_code}&state=#{state}&redirect_uri=#{redirect_uri}"
      authorization_code = client_application.generate_authorization_code
      client_application.update(authorization_code:)
      callback_url = redirect_uri + query_params
    else
      # redirect with error code?
    end
  end

  def approve; end
end
