class TeeworldsEntity

  DATA_REQUEST_TYPE_PLAYER_INFO = 'player_info'
  DATA_REQUEST_TYPE_PLAYERS_BY_RATING = 'players_by_rating'
  DATA_REQUEST_TYPE_CLAN_INFO = 'clan_info'

  def self.build_external_request(message_type, message_content)
    {:message_type => "external_message", :message_content =>
     {:external_message_type => message_type, :external_message_content => message_content}}
  end

  def self.build_data_request(data_request_type, content)
      build_external_request('data_request', {:data_request_type => data_request_type, :data_request_content => content})
  end

  def self.request_data(data_request_type, content)
    request = build_data_request(data_request_type, content)
    request_json = JSON.generate(request)
    s = TCPSocket.new '127.0.0.1', 12488
    s.puts request_json
    response_json = s.gets
    s.close
    puts response_json
    JSON.parse(response_json, symbolize_names: true)[:message_content][:external_message_content][:data_request_response_content]
  end

end
