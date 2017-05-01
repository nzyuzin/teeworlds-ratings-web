class PlayersController < ApplicationController

  def index
    @players = Player.players_by_rating 50, 0
  end

  def show
    player_name = params[:player_name]
    @player = Player.player_info player_name
    @user = User.find_by(player_name: player_name)
  end

end
