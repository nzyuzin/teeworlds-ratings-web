class GamesController < ApplicationController

  def index
    @games = Game.games_by_date(50, 0)
  end

  def show
    @game = Game.game_info(params[:id])
  end

end
