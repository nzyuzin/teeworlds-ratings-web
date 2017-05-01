class ClansController < ApplicationController

  def show
    clan_name = params[:clan_name]
    @clan = Clan.clan_info(clan_name)
    @players = @clan.players
  end

end
