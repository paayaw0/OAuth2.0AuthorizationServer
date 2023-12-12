FactoryBot.define do
  factory :client_application do
    name { Faker::Company.name }
    client_id { Faker::Alphanumeric.alpha(number: 25) }
    client_secret { Faker::Alphanumeric.alpha(number: 25) }
    authorization_code { Faker::Alphanumeric.alpha(number: 25) }
    access_token { Faker::Alphanumeric.alpha(number: 25) }
    refresh_token { Faker::Alphanumeric.alpha(number: 25) }
    redirect_uris { [Faker::Internet.url(path: '/callback')] }
    expires_in { DateTime.now }
    scopes { 'read' }
    grant_type { 'code' }
  end
end
