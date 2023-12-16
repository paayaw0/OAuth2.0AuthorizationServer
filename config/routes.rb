Rails.application.routes.draw do
  get '/authorize', to: 'authorization#authorize'
  post '/token', to: 'authorization#approve'
  get '/error', to: 'authorization#error'
end
