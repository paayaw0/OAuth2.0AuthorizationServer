Rails.application.routes.draw do
  get '/authorize', to: 'authorization#authorize'
  post '/token', to: 'authorization#approve'
  get '/unknown_client', to: 'authorization#unknown_client'
end
