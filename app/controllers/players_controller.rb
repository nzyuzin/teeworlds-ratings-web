class PlayersController < ApplicationController

  def index_ctf
    @players = Player.paginate_ctf(params[:page])
  end

  def index_dm
    @players = Player.paginate_dm(params[:page])
  end

  def show
    player_name = params[:player_name]
    @player = Player.player_info player_name
    @user = Player.find_by(name: player_name).user
  end

  def edit
    @player = Player.find_by(name: params[:player_name])
  end

  def update
    player = Player.find_by(name: params[:player_name])
    player.update(params[:player].permit(:about, :country, :avatar))
    redirect_to player_path(player)
  end

end
