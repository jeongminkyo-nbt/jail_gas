Rails.application.routes.draw do
  resources :credits
  root 'welcome#index'

  controller :credits do
    post '/pay_credit' => :payment
  end

  controller :receive_credits do
    get '/receive_credits' =>:index
    post '/receive_credits' => :return
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
