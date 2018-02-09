Rails.application.routes.draw do

  devise_for :users
  controller :receive_credits do
    get '/recent_credits' =>:recent_index
    post '/recent_credits' => :recent_return
    get '/receive_credits' => :receive_index
    post '/receive_credits' => :receive_return
  end

  controller :config do
    get '/config' => :index
  end
  resources :credits
  root 'welcome#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
