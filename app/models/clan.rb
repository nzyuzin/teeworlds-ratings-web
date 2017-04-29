class Clan
  attr_accessor :name, :rating, :players

  def self.parse(clan_hash)
    res = Clan.new
    res.name = clan_hash[:clan_name]
    res.rating = clan_hash[:clan_rating]
    res
  end
end
