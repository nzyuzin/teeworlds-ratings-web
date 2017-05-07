class Stats
  attr_accessor :hammer_kills, :gun_kills, :shotgun_kills, :grenade_kills, :rifle_kills,
    :deaths, :suicides, :flag_grabs, :flag_captures, :flag_returns, :flag_carrier_kills

  def self.parse(stats_hash)
    res = Stats.new
    res.hammer_kills = stats_hash[:hammer_kills]
    res.gun_kills = stats_hash[:gun_kills]
    res.shotgun_kills = stats_hash[:shotgun_kills]
    res.grenade_kills = stats_hash[:grenade_kills]
    res.rifle_kills = stats_hash[:rifle_kills]
    res.deaths = stats_hash[:deaths]
    res.suicides = stats_hash[:suicides]
    res.flag_grabs = stats_hash[:flag_grabs]
    res.flag_captures = stats_hash[:flag_captures]
    res.flag_returns = stats_hash[:flag_returns]
    res.flag_carrier_kills = stats_hash[:flag_carrier_kills]
    res
  end

  def kills
    hammer_kills + gun_kills + shotgun_kills + grenade_kills + rifle_kills
  end

  def kd
    # "\u221E" -- infinity symbol
    if deaths == 0 then "\u221E" else kills / deaths end
  end

end
