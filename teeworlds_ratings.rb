require 'sinatra/activerecord'
require 'sinatra/base'
require 'sinatra/paginate'

set :database, {adapter: "sqlite3", database: "rctf.db"}

Struct.new('Result', :total, :size, :players)

class Player < ActiveRecord::Base
end

class Clan < ActiveRecord::Base
end

class TeeworldsRatings < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  register Sinatra::Paginate

  helpers do
    def page
      [params[:page].to_i - 1, 0].max
    end
  end

  set :haml, :format => :html5

  get '/' do
    players_per_page = 50
    displayed_players = Player.offset(page * players_per_page).
      order("rating DESC").limit(players_per_page)
    @players = Struct::Result.new(Player.count, displayed_players.count, displayed_players)
    haml :index, :locals => {:players_per_page => players_per_page}
  end

  get '/players/:player' do |player_name|
    @player = Player.where(name: player_name).first
    haml :player
  end

  get '/clans/:clan' do |clan|
    @players = Player.where(clan: clan).all
    @clan = Clan.where(clan: clan).first
    haml :clan
  end

  get '/about' do
    haml :about
  end

  run! if app_file == $0
end
