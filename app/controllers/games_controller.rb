class GamesController < ApplicationController

  def show
    @game = Game.game_info(params[:id])
  end

end
