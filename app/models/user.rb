class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :timeoutable, :lockable

  validate :player_name_should_be_available

  def player_name_should_be_available
    request = {:message_type => "external_message", :message_content =>
     {:external_message_type => "registration_request", :external_message_content =>
      {:registration_request_type => "name_available", :registration_request_content =>
       {:name => self.player_name}}}}
    request_json = JSON.generate(request)
    s = TCPSocket.new '127.0.0.1', 12488
    s.puts request_json
    response_json = s.gets
    s.close
    answer = JSON.parse(response_json, symbolize_names: true)
    errors.add(:player_name, "This player name is already in use") unless answer[:message_content][:external_message_content][:registration_request_response_content] == true
  end

end
