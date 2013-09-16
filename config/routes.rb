Capitalism::Application.routes.draw do

  post '/vote/true' => 'votes#create', as: :true_vote, value: 'true'
  post '/vote/false' => 'votes#create', as: :false_vote, value: 'false'

  root to: 'votes#index'
end
