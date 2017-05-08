class TeeworldsEntity

  DATA_REQUEST_TYPE_PLAYER_INFO = 'player_info'
  DATA_REQUEST_TYPE_PLAYERS_BY_RATING = 'players_by_rating'
  DATA_REQUEST_TYPE_CLAN_INFO = 'clan_info'

  REGISTRATION_REQUEST_TYPE = {
    :register => 'register',
    :name_available => 'name_available',
    :join_clan => 'join_clan',
    :register_clan => 'register_clan'
  }

  def self.send_request(request)
    request_json = JSON.generate(request)
    s = nil
    begin
      s = TCPSocket.new Rails.configuration.teeworlds_ratings_ip, Rails.configuration.teeworlds_ratings_port
      s.puts request_json
      response_json = s.gets
      s.close
    rescue Errno::ECONNREFUSED
      raise 'Cannot connect to teeworlds-ratings server'
    ensure
      unless s.nil?
        s.close
      end
    end
    parsed_response = JSON.parse(response_json, symbolize_names: true)
    if parsed_response[:message_type] == 'error' then
      raise parsed_response[:message_content]
    else
      parsed_response[:message_content][:external_message_content]
    end
  end

  def self.build_external_request(message_type, message_content)
    {:message_type => "external_message", :message_content =>
     {:external_message_type => message_type, :external_message_content => message_content}}
  end

  def self.build_data_request(data_request_type, content)
      build_external_request('data_request', {:data_request_type => data_request_type, :data_request_content => content})
  end

  def self.request_data(data_request_type, content)
    request = build_data_request(data_request_type, content)
    response = send_request(request)
    response[:data_request_response_content]
  end

  def self.build_registration_request(registration_request_type, content)
      build_external_request('registration_request', {:registration_request_type => registration_request_type, :registration_request_content => content})
  end

  def self.request_registration(registration_request_type, content)
    request = build_registration_request(registration_request_type, content)
    response = send_request(request)
    response[:registration_request_response_content]
  end

end
