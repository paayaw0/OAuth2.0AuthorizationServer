class ClientApplication < ApplicationRecord
  def generate_authorization_code
    exp = (Time.now + 10.minutes).to_i
    payload = { client_id:, client_name: name, exp: }
    hmac_secret = Rails.application.secret_key_base

    JWT.encode payload, hmac_secret, 'HS256'
  end

  def generate_access_and_refresh_tokens; end
end
