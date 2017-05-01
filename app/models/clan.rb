class Clan < TeeworldsEntity
  attr_accessor :name, :rating, :players

  def self.parse(clan_hash)
    res = Clan.new
    res.name = clan_hash[:clan_name]
    res.rating = clan_hash[:clan_rating]
    res
  end

  def self.request_clan_info(name)
    request_data(DATA_REQUEST_TYPE_CLAN_INFO, {:name => name})
  end

  def self.clan_info(name)
    clan = request_clan_info(name)
    res = parse(clan[:clan])
    res.players = clan[:players].map { |p| Player.parse p }
    res
  end

end
