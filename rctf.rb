require 'sinatra/base'
require 'sinatra/paginate'
require 'sqlite3'

Struct.new('Result', :total, :size, :players)

class TeeworldsRatings < Sinatra::Base
  register Sinatra::Paginate

  helpers do
    def page
      [params[:page].to_i - 1, 0].max
    end
  end

  set :haml, :format => :html5
  set :bind, '0.0.0.0'

  def get_players()
    db = SQLite3::Database.new("rctf.db")
    rows = db.execute("select name, clan, rating from players")
    db.close()
    rows
  end

  get '/' do
    players_per_page = 50
    player_rows = get_players()
    displayed_players = player_rows[page * players_per_page, players_per_page]
    @players = Struct::Result.new(player_rows.length, displayed_players.length, displayed_players)
    haml :index, :locals => {:players_per_page => players_per_page}
  end

  get '/about' do
    haml :about
  end

  run! if app_file == $0
end
