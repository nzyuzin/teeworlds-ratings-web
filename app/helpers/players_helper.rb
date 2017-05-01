module PlayersHelper
  def format_game_length glen
    hours = glen / 3600
    minutes = (glen % 3600) / 60
    seconds = glen % 60
    res = ''
    res = res + "#{hours}h " if hours != 0
    res = res + "#{minutes}m " if minutes != 0
    res = res + "#{seconds}s"
    res
  end
end
