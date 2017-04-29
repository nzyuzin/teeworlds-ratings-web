Rails.application.routes.draw do

  devise_for :users
#Casein routes
namespace :casein do
    resources :news
end

  root to: 'news#index'

  get '/news/:id' => 'news#show'

  get '/about' => 'about#index'

  get '/players' => 'players#index'

  get '/players/:player_name' => 'players#show'

  get '/clans/:clan_name' => 'clans#show'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
