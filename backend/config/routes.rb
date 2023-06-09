Rails.application.routes.draw do
  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "graphql#execute"
  end
  post "/graphql", to: "graphql#execute"
  use_doorkeeper
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root :to => 'index#index'

  # Defines the root path route ("/")
  # root "articles#index"
  namespace :api do
    namespace :v1 do
      resources :tests
      # resources :users do
      #   resources :media
      #
      # end

    end
  end

  scope :api, defaults: { format: :json } do
    scope :v1 do
      use_doorkeeper do
        skip_controllers :authorizations, :applications, :authorized_applications
      end
      devise_for :users, controllers: { sessions: 'api/v1/users/sessions', registrations: 'api/v1/users/registrations'}
    end
  end
end
