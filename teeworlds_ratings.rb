require 'sinatra/activerecord'
require 'sinatra/base'
require 'sinatra/paginate'

set :database, {adapter: "sqlite3", database: "rctf.db"}

Struct.new('Result', :total, :size, :players)

class Player < ActiveRecord::Base
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

  get '/about' do
    haml :about
  end

  run! if app_file == $0
end
