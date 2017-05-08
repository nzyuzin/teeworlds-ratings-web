class ClansController < ApplicationController

  before_action :authenticate_user!, only: [:new, :create, :join]

  def index
  end

  def show
    clan_name = params[:clan_name]
    @clan = Clan.clan_info(clan_name)
    @players = @clan.players
  end

  def new
    @clan = Clan.new
  end

  def create
    clan = params[:clan]
    Clan.register(clan[:name], clan[:description], current_user.player_id)
  end

  def join
    Player.join_clan(current_user.player_id, params[:clan_id])
  end

end
