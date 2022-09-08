Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      get '/car_offers', to: 'car_offers#index'
    end
  end
end
