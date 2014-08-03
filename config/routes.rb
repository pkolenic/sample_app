SampleApp::Application.routes.draw do
  # This line mounts Forem's routes at /forums by default.
  # This means, any requests to the /forums URL of your application will go to Forem::ForumsController#index.
  # If you would like to change where this extension is mounted, simply change the :at option to something different.
  #
  # We ask that you don't use the :as option here, as Forem relies on it being the default of "forem"
  mount Forem::Engine, :at => '/forums'

  get "events/new"
  # Resource Paths
  resources :users, except: [:index]
  resources :clans, only: [:show] do
    resources :users
    resources :applications, only: [:index]
  end
  resources :applications, only: [:destroy]
  resources :events, only: [:new, :create, :destroy]
  resources :sessions, only: [:new, :create, :destroy]
  resources :tournaments, except: :index
  
  match '/signin',  to: 'sessions#new',         via: 'get'
  match '/signout', to: 'sessions#destroy',     via: 'delete'
  match '/users/:id/add_clanwar', to: 'users#add_clanwar', as:'add_clanwar', via: 'patch'
  match '/users/:id/remove_clanwar', to: 'users#remove_clanwar', as:'remove_clanwar', via: 'patch'
  
  match '/tournaments/:id/join', to: 'tournaments#join_tournament', as:'join_tournament', via: 'patch'
  match '/tournaments/:id/leave', to: 'tournaments#leave_tournament', as:'leave_tournament', via: 'patch'
  match '/tournaments/:id/close', to: 'tournaments#close_tournament', as:'close_tournament', via: 'patch'
  match '/tournaments/:id/open', to: 'tournaments#open_tournament', as:'open_tournament', via: 'patch'
  
  match 'users/:id/reset_password', to: 'users#reset_password', as:'reset_password', via: 'get'
  match 'users/:id/reset_password', to: 'users#update_password', as:'update_password', via: 'patch'
  
  
  match '/reset_password', to: 'users#request_password', as:'request_password', via: 'get'
  match '/reset_password', to: 'users#send_reset_request', as:'send_reset_request', via: 'patch'
  
  root  'static_pages#home'
  match '/signup',              to: 'users#new',                            via: 'get'
  match '/help',                to: 'static_pages#help',                    via: 'get'
  match '/links',               to: 'static_pages#links',                   via: 'get'
  match '/mods',                to: 'static_pages#mods',                    via: 'get'
  match '/messageboard',        to: 'static_pages#messageboard',            via: 'get'
  match '/about',               to: 'static_pages#about',                   via: 'get'
  match '/contact',             to: 'static_pages#contact',                 via: 'get'
  match '/schedule',            to: 'static_pages#schedule',                via: 'get'
  
  match '/riisingsun',          to: 'static_pages#riisingsun',              via: 'get'
  match '/wotvideos',           to: 'static_pages#wotvideos',               via: 'get'
  match '/wgnavideos',          to: 'static_pages#wgnavideos',              via: 'get'
  match '/mapvideos',           to: 'static_pages#mapvideos',               via: 'get'
  match '/teamtrainingvideos',  to: 'static_pages#teamtrainingvideos',      via: 'get'
  match '/tankvideos',          to: 'static_pages#tankvideos',              via: 'get'
  match '/ftfvideos',           to: 'static_pages#ftfvideos',               via: 'get'
  
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
