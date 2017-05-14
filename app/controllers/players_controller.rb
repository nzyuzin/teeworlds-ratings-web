class PlayersController < ApplicationController

  def index
    @players = Player.paginate(params[:page])
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
