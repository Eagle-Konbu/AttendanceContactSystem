class PasswordResetController < ApplicationController
    before_action :authenticate_executive_user!
    
    def index
        
    end

    def reset
        @user = ExecutiveUser.find(params[:id])
        new_password = SecureRandom.hex(5)

        @user.reset_password(new_password, new_password)

        redirect_to '/executive/new_password/' + @user.id.to_s + '/' + new_password
    end

    def show_new_password
        @user = ExecutiveUser.find(params[:id])
        @new_password = params[:new_password]
    end
end
