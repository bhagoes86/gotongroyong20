Rails.application.routes.draw do
  concern :votable do
    resources :votes, only: [:index, :create]
  end

  resources :problems

  get 'profiles/:id', :controller => 'profiles', :action => 'show'
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  get 'discourse/sso', :controller => 'discourse_sso', :action => 'sso'

  root to: 'pages#home'

  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      get 'locations/', controller: 'locations', action: 'provinces'
      get 'locations/:province_id/', controller: 'locations', action: 'kabupatens'
      get 'locations/:province_id/:kabupaten_id/', controller: 'locations', action: 'kecamatans'
      get 'locations/:province_id/:kabupaten_id/:kecamatan_id', controller: 'locations', action: 'kelurahans'

      scope 'problems' do
        resources :maps, only: [:index], controller: 'problems/maps'
        resources :details, only: [:index, :show], concerns: :votable, controller: 'problems/details', defaults: {model_name: 'Problem'} do
          resources :findings, only: [:index, :create, :destroy], concerns: :votable, controller: 'problems/findings', defaults: {model_name: 'Finding'}
        end
        resources :categories, only: [:index], controller: 'problems/categories'
      end
    end
  end
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
