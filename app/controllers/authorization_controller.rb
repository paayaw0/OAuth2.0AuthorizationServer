class AuthorizationController < ApplicationController  
  def authorize
    unless SupportedResponseTypes::RESPONSE_TYPES.include?(params['response_type'])
      redirect_to error_url(error: 'invalid_request',
                            error_description: 'Unsupported response type'                      
      )
    end

    client_application = ClientApplication.find_by(client_id: params['client_id'])
    redirect_uri = params['redirect_uri']
    scopes = params['scope']


    if client_application&.redirect_uris&.include?(redirect_uri)
      @state = params['state']
      @redirect_uri = redirect_uri
      @response_type = params['response_type']
      @scopes = scopes || client_application.minimum_scope_set
    else
      redirect_to error_url(error: 'invalid_request',
                                     error_description: 'client is not registered or provided an invalid redirect uri')
    end
  end

  def approve; end

  def error; end
end
