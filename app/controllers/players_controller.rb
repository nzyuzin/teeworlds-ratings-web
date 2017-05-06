class PlayersController < ApplicationController

  def index
    @players = Player.paginate(params[:page])
  end

  def show
    player_name = params[:player_name]
    @player = Player.player_info player_name
    @user = User.find_by(player_name: player_name)
  end

end
