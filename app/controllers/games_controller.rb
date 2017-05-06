class GamesController < ApplicationController

  def index
    @games = Game.paginate(params[:page])
  end

  def show
    @game = Game.game_info(params[:id])
  end

end
