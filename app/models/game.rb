class Game

  extend TeeworldsEntity

  class Participant

    attr_accessor :name, :score, :team, :rating_change, :stats

    def self.parse(hash)
      res = Participant.new
      res.name = hash[:player_name]
      res.score = hash[:score]
      res.team = hash[:team]
      res.rating_change = hash[:rating_change]
      res.stats = Stats.parse(hash[:stats])
      res
    end

  end

  attr_accessor :id, :gametype, :map, :time, :result, :date, :rating_change, :participants

  def self.per_page
    50
  end

  DATA_REQUEST_TYPES = {}
  DATA_REQUEST_TYPES[:game_info] = 'game_info'
  DATA_REQUEST_TYPES[:games_by_date] = 'games_by_date'

  def self.parse(game_hash)
    res = Game.new
    res.id = game_hash[:game_id]
    res.gametype = game_hash[:gametype]
    res.map = game_hash[:map]
    res.time = game_hash[:game_time]
    res.result = game_hash[:game_result]
    res.date = game_hash[:game_date]
    res.rating_change = game_hash[:rating_change]
    res
  end

  def self.request_game_info(id)
    request_data(DATA_REQUEST_TYPES[:game_info], {:game_id => id.to_i})
  end

  def self.game_info(id)
    game_info_hash = request_game_info(id)
    res = self.parse game_info_hash[:game]
    res.participants = game_info_hash[:participants].map {|p| Participant.parse p}
    res
  end

  def self.request_games_by_date(limit, offset)
    request_data(DATA_REQUEST_TYPES[:games_by_date], {:limit => limit, :offset => offset})
  end

  def self.games_by_date(limit, offset)
    games_by_date_hash = request_games_by_date(limit, offset)
    games = games_by_date_hash[:games].map {|g| Game.parse(g)}
    total_games = games_by_date_hash[:total_games]
    {:games => games, :total_games => total_games}
  end

  def self.paginate(page)
    page = 1 if page.nil?
    games_by_date_hash = games_by_date(per_page, (page.to_i - 1) * per_page)
    WillPaginate::Collection.create(page, per_page, games_by_date_hash[:total_games]) do |pager|
      pager.replace games_by_date_hash[:games]
    end
  end

end
