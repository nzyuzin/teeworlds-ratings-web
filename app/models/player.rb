class Player < TeeworldsEntity

  attr_accessor :name, :clan, :clan_id, :rating, :games, :secret_key, :total_games, :stats

  def self.per_page
    50
  end

  def self.parse(player_hash)
    res = Player.new
    res.name = player_hash[:name]
    res.clan_id = player_hash[:clan_id]
    res.rating = player_hash[:rating]
    res.secret_key = player_hash[:secret_key]
    res
  end

  def self.request_player_info(name)
    request_data(DATA_REQUEST_TYPE_PLAYER_INFO, {:name => name})
  end

  def self.player_info(name)
    pinfo = request_player_info(name)
    player = pinfo[:player]
    res = self.parse player
    res.games = pinfo[:games].map { |game| Game.parse(game) }
    res.clan = pinfo[:clan_name]
    res.total_games = pinfo[:total_games]
    res.stats = Stats.parse(pinfo[:stats])
    res
  end

  def self.request_players_by_rating(limit, offset)
    request_data(DATA_REQUEST_TYPE_PLAYERS_BY_RATING, {:limit => limit, :offset => offset})
  end

  def self.players_by_rating(limit, offset)
    response_hash = request_players_by_rating(limit, offset)
    players = response_hash[:players_with_clan_names].map do |p|
      pl = Player.parse(p[:player])
      pl.clan = p[:clan_name]
      pl
    end
    total_players = response_hash[:total_players]
    {:players => players, :total_players => total_players}
  end

  def self.paginate(page)
    page = 1 if page.nil?
    players_by_rating_hash = players_by_rating(per_page, (page.to_i - 1) * per_page)
    WillPaginate::Collection.create(page, per_page, players_by_rating_hash[:total_players]) do |pager|
      pager.replace players_by_rating_hash[:players]
    end
  end

  def self.request_name_available(name)
    request_registration(REGISTRATION_REQUEST_TYPE[:name_available], {:name => name})
  end

  def self.name_available?(name)
    request_name_available(name)
  end

  def self.request_register(name)
    request_registration(REGISTRATION_REQUEST_TYPE[:register], {:name => name})
  end

  def self.register(name)
    request_register(name)
  end

  def self.request_join_clan(player_id, clan_id)
    request_registration(REGISTRATION_REQUEST_TYPE[:join_clan],
                         {:player_id => player_id, :clan_id => clan_id})
  end

  def self.join_clan(player_id, clan_id)
    request_join_clan(player_id, clan_id)
  end

end
