Rails.application.routes.draw do

  resources :delivaries
  devise_for :users
  controller :receive_credits do
    get '/recent_credits' =>:recent_index
    post '/recent_credits' => :recent_return
    get '/receive_credits' => :receive_index
    post '/receive_credits' => :receive_return
  end

  controller :daily_closing do
    get '/daily_closing' => :index
    get '/daily_closing/closing' =>:closing, :as => 'daily_closing_report'
    get '/daily_closing/:id' => :show, :as => 'daily_closing_show'
    post '/daily_closing' => :create, :as => 'daily_closing_create'
    post '/daily_closing/update_delivary' => :update_delivary
    post '/daily_closing/add_delivary' => :add_delivary
    post '/daily_closing/update_credit' => :update_credit
  end
  controller :config do
    get '/configs' => :index
    get '/configs/edit' => :edit, :as => 'edit_config'
    post '/configs/edit' => :update
  end

  controller :company_hosing do
    get '/company_housing' => :company_hosing
    get '/company_housing/edit' => :edit, :as => 'edit_company_housing'
    get '/company_housing/update/:id' => :edit_people, :as =>'edit_people'
    post '/company_housing/update' => :apply_edit_people
    post '/company_housing/edit/set_update' => :set_update
    get '/company_housing/add_people' => :add_people
    post '/company_housing' => :update_people, :as => 'update_people'
  end

  resources :credits
  root 'welcome#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
