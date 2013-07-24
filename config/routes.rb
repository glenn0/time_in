TimeIn::Application.routes.draw do
  root to: 'pages#index'

  get "/" => 'pages#index'

  post '/time_location', to: 'time#create'
end