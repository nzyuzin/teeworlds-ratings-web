class Player
  attr_accessor :name, :clan, :rating, :games

  def self.parse(player_hash)
    res = Player.new
    res.name = player_hash[:name]
    res.clan = player_hash[:clan]
    res.rating = player_hash[:rating]
    res
  end
end
