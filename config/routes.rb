Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :sessions, only: :create
      resources :facilities, only: %i[index]
      resources :timeslots, only: %i[index]
      resources :bookings, only: %i[index create update destroy]
    end
  end
end
