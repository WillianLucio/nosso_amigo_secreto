require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users, :controllers => { registrations: 'registrations' }
  mount Sidekiq::Web => '/sidekiq'

  root to: 'pages#home'
  resources :campaigns, except: [:new] do
    post 'raffle', on: :member            # (Obs: com o member ele coloca o id        - campaign/:id/raffle)
    # post 'raffle', on: :collection        (Obs: Com o colection ele não coloca o id - campaign/raffle)
  end
  get 'members/:token/opened', to: 'members#opened'
  resources :members, only: [:create, :destroy, :update]
end
