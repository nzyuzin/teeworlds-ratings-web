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

  get '/players/:player_name', to: 'players#show', as: 'player'

  get '/clans' => 'clans#index'

  get '/clans/new', to: 'clans#new', as: 'new_clan'

  post '/clans' => 'clans#create'

  get '/clans/:clan_name', to: 'clans#show', as: 'clan'

  post '/clans/join/:clan_id' => 'clans#join', as: 'join_clan'

  get '/games' => 'games#index'

  get '/games/:id', to: 'games#show', as: 'game'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
