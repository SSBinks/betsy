Rails.application.routes.draw do

    root 'home#index'

    resources :merchants, only: [:show] do
        resources :products
        resources :orders, except: [:new, :create, :delete]
        # NESTED? do
        #     resources :order_items, only: [:update]
        # end
    end

    resources :products, only: [:index, :show] do
        resources :reviews, only: [:new, :create]
    end

    resources :categories, only: [:new, :create, :show]



# We're going to talk about this more if any of us needs to edit this. :)
    resources :orders, only: [:new, :create, :show] do
        resources :order_items, except: [:index, :show]
    end

# Sessions routes - can be further flushed out...
    get '/auth/:provider/callback' =>  'sessions#create'

    get "/sessions/login_failure", to: "sessions#login_failure", as: "login_failure"

    get '/sessions', to: 'sessions#index', as: 'sessions'

    delete '/sessions', to: 'sessions#destroy'

    #specific routes for the cart!
    get '/carts' => 'carts#index'
    get 'carts/empty_cart' =>'carts#empty_cart'
    get '/carts/:id', to: 'carts#add_to_cart', as: "add_cart"
    get '/carts/:id', to: 'carts#sub_cart', as: "sub_cart"
    delete '/carts/products/:id', to: 'carts#destroy', as: 'delete_cart'

end
