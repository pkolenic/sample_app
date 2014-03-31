FTFESO::Application.routes.draw do
  # Resource Paths
  resources :users
  resources :runes, except: [:show]
  resources :essence_runes, only: [:edit, :update, :destroy]
  resources :aspect_runes, only: [:edit, :update, :destroy]
  resources :potency_runes, only: [:edit, :update, :destroy]
  
  resources :sessions, only: [:new, :create, :destroy]
  resources :events, only: [:create, :destroy, :index, :show]
  
  match 'users/:id/reset_password', to: 'users#reset_password', as:'reset_password', via: 'get'
  match 'users/:id/reset_password', to: 'users#update_password', as:'update_password', via: 'patch'
  match '/reset_password', to: 'users#request_password', as:'request_password', via: 'get'
  match '/reset_password', to: 'users#send_reset_request', as:'send_reset_request', via: 'patch'
  
  match '/signin',            to: 'sessions#new',               via: 'get'
  match '/signout',           to: 'sessions#destroy',           via: 'delete'
  match '/users/:id/approve', to: 'users#approve', as: 'approve', via: 'patch'
  
  match '/alchemy_book',      to: 'books#alchemy_book',         via: 'get'
  match '/blacksmithing_book',to: 'books#blacksmithing_book',   via: 'get'
  match '/clothing_book',     to: 'books#clothing_book',        via: 'get'
  match '/enchanting_book',   to: 'books#enchanting_book',      via: 'get'
  match '/provisioning_book', to: 'books#provisioning_book',    via: 'get'
  match '/quests_book',       to: 'books#quests_book',          via: 'get'
  match '/woodworking_book',  to: 'books#woodworking_book',     via: 'get'
  
  root  'static_pages#home'
  match '/signup',            to: 'users#new',                  via: 'get'
  match '/about',             to: 'static_pages#about',         via: 'get'
  match '/contact',           to: 'static_pages#contact',       via: 'get'
  match '/guildhall',         to: 'static_pages#guildhall',     via: 'get'
  match '/library',           to: 'static_pages#library',       via: 'get'
  match '/messageboard',      to: 'static_pages#messageboard',  via: 'get'
  match '/calendar',          to: 'events#index',               via: 'get'
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
