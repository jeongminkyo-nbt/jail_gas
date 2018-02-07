Rails.application.routes.draw do

  controller :receive_credits do
    get '/recent_credits' =>:index
    post '/recent_credits' => :return
    get '/receive_credits' => :index_
    post '/receive_credits' => :return_
  end

  resources :credits
  root 'welcome#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
