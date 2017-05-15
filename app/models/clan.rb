class Clan < ApplicationRecord
  extend TeeworldsEntity

  DATA_REQUEST_TYPE = { :clan_info => 'clan_info'}

  REGISTRATION_REQUEST_TYPE = {
    :register_clan => 'register_clan'
  }

  has_many :players
  has_many :clan_leaders

  attr_accessor :sub_clan_id, :average_rating

  def self.parse(clan_hash)
    res = Clan.find_by(remote_id: clan_hash[:id])
    if res.name != clan_hash[:clan_name] then
      fail 'Fetched clan_name doesn\'t match the one in db!'
    end
    res.sub_clan_id = clan_hash[:sub_clan_id]
    res
  end

  def self.register(clan, clan_leader)
    body = {:name => clan.name, :clan_leader => clan_leader.remote_id}
    remote_id = request_registration(REGISTRATION_REQUEST_TYPE[:register_clan], body)
    if remote_id.nil?
      fail 'Could not register clan in the remote db!'
    end
    clan.remote_id = remote_id
  end

  def self.request_clan_info(name)
    request_data(DATA_REQUEST_TYPE[:clan_info], {:name => name})
  end

  def self.clan_info(name)
    clan = request_clan_info(name)
    res = parse(clan[:clan])
    res.players = clan[:players].map { |p| Player.parse p }
    res.average_rating = clan[:average_rating]
    res
  end

end
