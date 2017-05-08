class RegistrationsController < Devise::RegistrationsController
  before_filter :configure_permitted_parameters, :only => [:create, :update]

  protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:player_name, :country, :email, :password) }
      devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:country, :email, :password, :password_confirmation, :current_password) }
    end
end
