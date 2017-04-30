class Player
  attr_accessor :name, :clan, :rating, :games, :secret_key

  def self.parse(player_hash)
    res = Player.new
    res.name = player_hash[:name]
    res.clan = player_hash[:clan]
    res.rating = player_hash[:rating]
    res.secret_key = player_hash[:secret_key]
    res
  end
end
