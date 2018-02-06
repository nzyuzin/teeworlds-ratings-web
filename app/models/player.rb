class Player < ApplicationRecord

  extend TeeworldsEntity

  DATA_REQUEST_TYPE = {
    :player_info => 'player_info',
    :players_by_rating => 'players_by_rating'
  }

  REGISTRATION_REQUEST_TYPE = {
    :register => 'register',
    :name_available => 'name_available',
    :join_clan => 'join_clan',
  }

  belongs_to :user
  belongs_to :clan

  has_attached_file :avatar, styles: { medium: "150x150>", thumb: "90x90>" }, default_url: "/images/missing_:style.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/

  attr_accessor :ctf_rating, :dm_rating, :games, :secret_key, :total_games, :stats

  def self.per_page
    50
  end

  def self.parse(player_hash)
    res = Player.find_by(remote_id: player_hash[:id])
    if res.name != player_hash[:name] then
      fail 'Fetched player_name doesn\'t match the on in db!'
    end
    unless ((res.clan_id.nil? && player_hash[:clan_id] == -1) || # both undefined
            res.clan_id == player_hash[:clan_id]) then # or the same
      fail 'Fetched clan_id doesn\'t match the one in db!'
    end
    res.ctf_rating = player_hash[:ctf_rating]
    res.dm_rating = player_hash[:dm_rating]
    res.secret_key = player_hash[:secret_key]
    res
  end

  def self.player_info(name)
    pinfo = request_data(DATA_REQUEST_TYPE[:player_info], {:name => name})
    player = pinfo[:player]
    res = self.parse player
    res.games = pinfo[:games].map { |game| Game.parse(game) }
    res.total_games = pinfo[:total_games]
    res.stats = Stats.parse(pinfo[:stats])
    res
  end

  def self.players_by_rating(limit, offset, rating_type)
    response_hash = request_data(DATA_REQUEST_TYPE[:players_by_rating], {:limit => limit, :offset => offset, :rating => rating_type})
    players = response_hash[:players].map { |p| Player.parse(p) }
    total_players = response_hash[:total_players]
    {:players => players, :total_players => total_players}
  end

  def self.paginate(page, rating)
    page = 1 if page.nil?
    players_by_rating_hash = players_by_rating(per_page, (page.to_i - 1) * per_page, rating)
    WillPaginate::Collection.create(page, per_page, players_by_rating_hash[:total_players]) do |pager|
      pager.replace players_by_rating_hash[:players]
    end
  end

  def self.paginate_ctf(page)
    paginate(page, 'ctf')
  end

  def self.paginate_dm(page)
    paginate(page, 'dm')
  end

  def self.name_available?(player)
    request_registration(REGISTRATION_REQUEST_TYPE[:name_available], {:name => player.name})
  end

  def self.register(player)
    remote_id = request_registration(REGISTRATION_REQUEST_TYPE[:register], {:name => player.name})
    if remote_id.nil? then
      fail 'Could not register the player in the remote db!'
    end
    player.remote_id = remote_id
  end

  def self.join_clan(player, clan)
    type = REGISTRATION_REQUEST_TYPE[:join_clan]
    request_res = request_registration(type, {:player_id => player.remote_id, :clan_id => clan.remote_id})
    if request_res.nil?
      fail 'Could not join clan in the remote db!'
    end
    player.clan = clan
    player.save!
  end

  def to_param
    name
  end

end
