class ClansController < ApplicationController

  before_action :authenticate_user!, only: [:new, :create, :join]

  def index
  end

  def show
    clan_name = params[:clan_name]
    @clan = Clan.clan_info(clan_name)
    @players = @clan.players
    @clan_leader = Player.find(@clan.clan_leader_id)
  end

  def new
    @clan = Clan.new
  end

  def create
    clan = Clan.new(params[:clan].permit(:name, :about))
    player = current_user.player
    Clan.register(clan, player.remote_id)
    player.clan = clan
    clan.save!
    player.save!
    redirect_to clan_path(clan.name)
  end

  def join
    clan = Clan.find_by(params[:clan_id])
    Player.join_clan(current_user.player, clan)
    redirect_to clan_path(clan.name)
  end

end
