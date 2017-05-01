class Player < TeeworldsEntity
  attr_accessor :name, :clan, :rating, :games, :secret_key

  def self.parse(player_hash)
    res = Player.new
    res.name = player_hash[:name]
    res.clan = player_hash[:clan]
    res.rating = player_hash[:rating]
    res.secret_key = player_hash[:secret_key]
    res
  end

  def self.request_player_info(name)
    request_data(DATA_REQUEST_TYPE_PLAYER_INFO, {:name => name})
  end

  def self.player_info(name)
    player_games = request_player_info(name)
    player = player_games[:player]
    res = self.parse player
    res.games = player_games[:games].map { |game| Game.parse(game) }
    res
  end

  def self.request_players_by_rating(limit, offset)
    request_data(DATA_REQUEST_TYPE_PLAYERS_BY_RATING, {:limit => limit, :offset => offset})
  end

  def self.players_by_rating(limit, offset)
    players = request_players_by_rating(limit, offset)
    players.map { |p| self.parse(p) }
  end
end
