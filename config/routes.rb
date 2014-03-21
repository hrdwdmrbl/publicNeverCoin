NeverCoin::Application.routes.draw do
  devise_for :users, controllers: {
      registrations: "registrations",
      sessions: "sessions"
    },
    sign_out_via: [ :get, :delete, :post ]
  resources :payments
  get '/about' => 'statics#about'
  root to: "statics#launch"
end
