class ApplicationController < ActionController::Base
    include SupportedResponseTypes
    
    before_action :authenticate_resource_owner!
    before_action :authenticate_client_application!


    private

    def authenticate_resource_owner!
        # authenticate resource owner
    end

    def authenticate_client_application!
        # authenticate client application
    end
end
