Rails.application.routes.draw do
  get '/authorize', to: 'authorization#authorize'
  post '/approve', to: 'authorization#approve'
end
