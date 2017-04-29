class PlayersController < ApplicationController

  def get_player(name)
    request = {:message_type => "external_message", :message_content =>
     {:external_message_type => "data_request", :external_message_content =>
      {:data_request_type => "player_info", :data_request_content =>
       {:name => name}}}}
    request_json = JSON.generate(request)
    s = TCPSocket.new '127.0.0.1', 12488
    s.puts request_json
    response_json = s.gets
    s.close
    puts response_json
    players_json = JSON.parse(response_json, symbolize_names: true)
    player_games = players_json[:message_content][:external_message_content][:data_request_response_content]
    player = player_games[:player]
    res = Player.parse player
    res.games = player_games[:games].map { |game| Game.parse(game) }
    res
  end

  def get_players(offset, limit)
    request = {:message_type => "external_message", :message_content =>
     {:external_message_type => "data_request", :external_message_content =>
      {:data_request_type => "players_by_rating", :data_request_content =>
       {:limit => limit, :offset => offset}}}}
    request_json = JSON.generate(request)
    s = TCPSocket.new '127.0.0.1', 12488
    s.puts request_json
    response_json = s.gets
    s.close
    players_json = JSON.parse(response_json, symbolize_names: true)
    players = players_json[:message_content][:external_message_content][:data_request_response_content]
    players.map { |p| Player.parse(p) }
  end

  def index
    @players = get_players 0, 50
  end

  def show
    player_name = params[:player_name]
    @player = get_player player_name
  end

  def claim_name
    puts "Claim name #{params[:player_name]}"
  end
end
