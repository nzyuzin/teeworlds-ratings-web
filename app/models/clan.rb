class Clan < TeeworldsEntity
  attr_accessor :name, :description, :sub_clan_id, :players, :average_rating, :clan_leader_id

  def self.parse(clan_hash)
    res = Clan.new
    res.name = clan_hash[:clan_name]
    res.description = clan_hash[:description]
    res.sub_clan_id = clan_hash[:sub_clan_id]
    res
  end

  def self.register(clan_name, description, clan_leader_id)
    body = {:name => clan_name, :description => description, :clan_leader => clan_leader_id}
    request_registration(REGISTRATION_REQUEST_TYPE[:register_clan], body)
  end

  def self.request_clan_info(name)
    request_data(DATA_REQUEST_TYPE_CLAN_INFO, {:name => name})
  end

  def self.clan_info(name)
    clan = request_clan_info(name)
    res = parse(clan[:clan])
    res.players = clan[:players].map { |p| Player.parse p }
    res.average_rating = clan[:average_rating]
    res
  end

end
