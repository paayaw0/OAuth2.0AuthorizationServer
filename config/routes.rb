Rails.application.routes.draw do
  get 'authorization/authorize'
  get '/authorize', to: 'authorization#authorize'
end
