Rails.application.routes.draw do

  get '/' => 'players#index'

  get '/about' => 'about#index'

  get 'players/:player_name' => 'players#show'

  get 'clans/:clan_name' => 'clans#show'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
