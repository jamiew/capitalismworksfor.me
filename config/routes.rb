Capitalism::Application.routes.draw do

  # resources :votes
  post '/votes' => 'votes#create', as: :create_vote
  delete '/votes' => 'votes#destroy', as: :destroy_vote

  root to: 'votes#index'
end
