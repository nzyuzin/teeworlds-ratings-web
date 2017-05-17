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

  get '/ctf/players' => 'players#index_ctf'
  get '/dm/players' => 'players#index_dm'
  get '/players/:player_name', to: 'players#show', as: 'player'
  put '/players/:player_name', to: 'players#update'
  patch '/players/:player_name', to: 'players#update'
  get '/players/:player_name/edit', to: 'players#edit', as: 'edit_player'

  get '/clans' => 'clans#index'
  get '/clans/new', to: 'clans#new', as: 'new_clan'
  post '/clans' => 'clans#create'
  get '/clans/:clan_name', to: 'clans#show', as: 'clan'
  post '/clans/:clan_id/join' => 'clans#join', as: 'join_clan'

  get '/games' => 'games#index'
  get '/games/:id', to: 'games#show', as: 'game'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
