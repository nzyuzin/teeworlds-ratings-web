Rails.application.routes.draw do

  devise_for :users, :controllers => { :registrations => "registrations" }

  #Casein routes
  namespace :casein do
      resources :news
  end

  root to: 'news#index'

  get '/news/:id' => 'news#show'

  get '/about' => 'about#index'

  get '/howto' => 'about#howto'

  get '/players' => 'players#index'

  get '/players/:player_name' => 'players#show'

  get '/clans' => 'clans#index'

  get '/clans/new' => 'clans#new'

  post '/clans' => 'clans#create'

  get '/clans/:clan_name' => 'clans#show'

  post '/clans/join/:clan_id' => 'clans#join'

  get '/games' => 'games#index'

  get '/games/:id' => 'games#show'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
