class Player < TeeworldsEntity
  attr_accessor :name, :clan, :rating, :games, :secret_key

  REGISTRATION_REQUEST_TYPE = {:register => 'register', :name_available => 'name_available'}

  def self.build_registration_request(registration_request_type, content)
      build_external_request('registration_request', {:registration_request_type => registration_request_type, :registration_request_content => content})
  end

  def self.request_registration(registration_request_type, content)
    request = build_registration_request(registration_request_type, content)
    response = send_request(request)
    response[:registration_request_response_content]
  end

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
    res.games = player_games[:games].map { |game| Game.parse({:game => game}) }
    res
  end

  def self.request_players_by_rating(limit, offset)
    request_data(DATA_REQUEST_TYPE_PLAYERS_BY_RATING, {:limit => limit, :offset => offset})
  end

  def self.players_by_rating(limit, offset)
    players = request_players_by_rating(limit, offset)
    players.map { |p| self.parse(p) }
  end

  def self.request_name_available(name)
    request_registration(REGISTRATION_REQUEST_TYPE[:name_available], {:name => name})
  end

  def self.name_available?(name)
    request_name_available(name)
  end

  def self.request_register(name, clan)
    request_registration(REGISTRATION_REQUEST_TYPE[:register], {:name => name, :clan => clan})
  end

  def self.register(name, clan)
    request_register(name, clan)
  end
end
