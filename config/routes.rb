Rails.application.routes.draw do

  post '/pay_credit', to: 'credits#payment'

  controller :receive_credits do
    get '/receive_credits' =>:index
    post '/receive_credits' => :return
  end

  resources :credits
  root 'welcome#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
