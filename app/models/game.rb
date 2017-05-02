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

  def self.parse(container_hash)
    res = Game.new
    game_hash = container_hash[:game]
    res.id = game_hash[:game_id]
    res.gametype = game_hash[:gametype]
    res.map = game_hash[:map]
    res.time = game_hash[:game_time]
    res.result = game_hash[:game_result]
    res.date = game_hash[:game_date]
    res.rating_change = game_hash[:rating_change]
    res.participants = container_hash[:participants].map {|p| Participant.parse p} unless container_hash[:participants].nil?
    res
  end

  def self.request_game_info(id)
    request_data(DATA_REQUEST_TYPE_GAME_INFO, {:game_id => id.to_i})
  end

  def self.game_info(id)
    self.parse request_game_info(id)
  end

end
