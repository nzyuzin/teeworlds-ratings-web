class Game
  attr_accessor :id, :gametype, :map, :time, :result, :date, :rating_change

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
end
