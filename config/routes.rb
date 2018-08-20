require 'sidekiq/web'
require 'sidekiq-scheduler/web'

#
Rails.application.routes.draw do
  devise_for :admins, controllers: {
    sessions:           'backend/accounts/sessions',
    passwords:          'backend/accounts/passwords',
    registrations:      'backend/accounts/registrations',
    unlocks:            'backend/accounts/unlocks',
    # omniauth_callbacks: "backend/accounts/omniauth_callbacks"
  }
  as :admin do
    # get 'admins/sign_out' => "backend/accounts/sessions#destroy"
    get 'admins/profile' => 'backend/accounts/registrations#profile', :as => :edit_admin_profile
    # put 'admins'
    # get 'admins/edit'

    put 'admins/update_password' => 'backend/accounts/registrations#update_password', :as => :update_admin_password

    get 'admins/switch_role' => 'backend/accounts/registrations#switch_role', as: :switch_admin_role, :defaults => { :format => 'json' }

    get 'admins/become' => 'backend/accounts/registrations#become', as: :switch_admin_account, :defaults => { :format => 'json' }
    
    get 'admins/unbind_sns' => 'backend/accounts/registrations#unbind_sns', as: :unbind_sns_account, :defaults => { :format => 'json' }
  end

  # authenticate :admin do
  authenticate :admin, lambda { |u| u.super? } do
    Sidekiq::Web.set :sessions, false
    mount Sidekiq::Web => '/sidekiq'
  end

  devise_scope :admin do
    namespace :wechat do
      namespace :v1 do
        get "sign_in" => "wechats#new"
        post "sign_up" => "wechats#create"
      end
    end
  end

  namespace :backend do

    # resources :catgs do
    #   collection do
    #     get :selects
    #   end
    #   resources :tag_keys, :path=>:keys, :as=>:keys
    # end
    # resources :tag_keys do
    #   collection do
    #     get 'import' => "tag_keys#new_import"
    #   end
    #   member do
    #     put :import
    #   end
    # end
    resources :admins do
      collection do
      end
      member do
        post :lock
      end
    end

    resources :areas

    # resources :branches
    # resources :financial_products
    # resources :customer_products
    # resources :customers
    # resources :bank_cards
    # resources :imports, only: [:index, :show] do
    #   collection do
    #     get 'new_customer'
    #     post 'up_customer'

    #     get 'new_financial'
    #     post 'up_financial'
    #   end

    #   member do
    #     post 'do_process'
    #     post 'do_reset'
    #     get 'process_customer'
    #     get 'customer_done'

    #     get 'process_financial'
    #     get 'financial_done'
    #   end
    # end
    # resources :admin_logs, except: [:update, :create]

    # post 'home/titles' => 'home#titles'
    # get 'home/tags' => 'home#tags'
    root 'home#index'
  end

  # root :to => 'home#index'
  match '/', to: redirect('/backend/'), as: :root, via: [:get, :post]

  # match '(*any)' , to: redirect('/backend/'), via: [:get, :post]
end
