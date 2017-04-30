class RegistrationsController < Devise::RegistrationsController
  before_filter :configure_permitted_parameters, :only => [:create, :update]

  def register_player(name, clan)
    request = {:message_type => "external_message", :message_content =>
     {:external_message_type => "registration_request", :external_message_content =>
      {:registration_request_type => "register", :registration_request_content =>
       {:name => name, :clan => clan}}}}
    request_json = JSON.generate(request)
    s = TCPSocket.new '127.0.0.1', 12488
    s.puts request_json
    response_json = s.gets
    s.close
    answer = JSON.parse(response_json, symbolize_names: true)
  end

  def create
    super
    register_player(params[:user][:player_name], params[:user][:player_clan]) unless @user.invalid?
  end

  protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:player_name, :player_clan, :country, :email, :password) }
      devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:player_clan, :country, :email, :password, :password_confirmation, :current_password) }
    end
end
