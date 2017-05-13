class PlayersController < ApplicationController

  def index
    @players = Player.paginate(params[:page])
  end

  def show
    player_name = params[:player_name]
    @player = Player.player_info player_name
    @user = Player.find_by(name: player_name).user
  end

end
