Rails.application.routes.draw do
  namespace :v1 do
    get "open_ai", to: "open_ai#show"

    resources :folders, only: [:index, :create]
    resources :audios, only: [:index, :create]
  end
end
