class ClansController < ApplicationController

  def get_clan(name)
    request = {:message_type => "external_message", :message_content =>
     {:external_message_type => "data_request", :external_message_content =>
      {:data_request_type => "clan_info", :data_request_content =>
       {:name => name}}}}
    request_json = JSON.generate(request)
    s = TCPSocket.new '127.0.0.1', 12488
    s.puts request_json
    response_json = s.gets
    s.close
    clan_json = JSON.parse(response_json, symbolize_names: true)
    clan = clan_json[:message_content][:external_message_content][:data_request_response_content]
    res = Clan.parse(clan[:clan])
    res.players = clan[:players].map { |p| Player.parse p }
    res
  end

  def show
    clan_name = params[:clan_name]
    @clan = get_clan clan_name
    @players = @clan.players
  end
end
