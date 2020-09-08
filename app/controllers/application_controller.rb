class ApplicationController < ActionController::Base
    before_action :configure_permitted_parameters, if: :devise_controller?

    protected
  
    def configure_permitted_parameters
      #strong parametersを設定し、usernameを許可
      devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:user_id, :password, :password_confirmation, :admin, :receive_email, [:email]) }
      devise_parameter_sanitizer.permit(:sign_in) { |u| u.permit(:user_id, :password, :password_confirmation) }
      devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:user_id, :nickname, :current_password, :password, :password_confirmation, :admin, :receive_email, [:email]) }
    end

    def after_sign_out_path_for(resource)
      new_executive_user_session_path
    end
end
