Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get "/merchants/:id/dashboard", to: 'merchant/dashboards#show'

  post "/merchants/:id/bulk_discounts/new", to: 'bulk_discounts#create'

  resources :merchants, except: [:index, :show, :edit, :destroy, :new, :create, :update]  do
    resources :bulk_discounts
    resources :items, only: [:index, :show, :edit, :update, :new, :create], controller: "merchant/items"
    resources :invoices, only: [:index, :show], controller: "merchant/invoices"
    resources :invoice_items, only: [:update], controller: "merchant/invoice_items"
  end

  resources :admin, only: :index
  namespace :admin do
    resources :merchants, except: [:destroy]
    resources :invoices, only: [:index, :show, :update]
  end
end
