Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :sessions, only: :create
      resources :facilities, only: %i[index]
    end
  end
end
