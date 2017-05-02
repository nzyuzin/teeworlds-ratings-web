class Game < TeeworldsEntity
  class Participant
    attr_accessor :name, :score, :team, :rating_change

    def self.parse(hash)
      res = Participant.new
      res.name = hash[:player_name]
      res.score = hash[:score]
      res.team = hash[:team]
      res.rating_change = hash[:rating_change]
      res
    end

  end

  attr_accessor :id, :gametype, :map, :time, :result, :date, :rating_change, :participants

  DATA_REQUEST_TYPE_GAME_INFO = 'game_info'

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
    request_data(DATA_REQUEST_TYPE_GAME_INFO, {:game_id => id.to_i})
  end

  def self.game_info(id)
    game_info_hash = request_game_info(id)
    res = self.parse game_info_hash[:game]
    res.participants = game_info_hash[:participants].map {|p| Participant.parse p}
    res
  end

end
