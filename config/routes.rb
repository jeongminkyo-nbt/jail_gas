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
    get '/daily_closing/:id/edit' => :edit, :as =>'daily_closing_edit'
    post '/daily_closing' => :create, :as => 'daily_closing_create'
    post '/daily_closing/update_delivary' => :update_delivary
    post '/daily_closing/add_delivary' => :add_delivary
    post '/daily_closing/update_credit' => :update_credit
    post '/daily_closing/:id' => :edit_closing, :as => 'daily_closing_edit_closing'
    post '/daily_closing/:id/edit/destroy' => :delete_credit, :as => 'daily_closing_delete'
    post '/daily_closing/:id/edit_delivary' => :edit_delivary, :as =>'daily_closing_edit_delivary'
  end

  controller :config do
    get '/configs' => :index
    get '/configs/edit' => :edit, :as => 'edit_config'
    post '/configs/edit' => :update
  end

  controller :warehouse do
    get '/warehouse' => :index
    post '/warehouse' => :create, :as => 'warehouse_create'
    get '/warehouse/new' => :new
    get '/warehouse/:id/edit' =>:edit
    put '/warehouse/:id' =>:update, :as => 'warehouse_update'
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
