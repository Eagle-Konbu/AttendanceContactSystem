class ExecutiveController < ApplicationController
  before_action :authenticate_executive_user!, only: :index

  def index
    @account = current_executive_user
    @msg = current_executive_user.nickname + "さんこんにちは！"
    @admin = current_executive_user.admin
    @subsection_cheif = current_executive_user.position == 'subsection_cheif'

    if @admin then
      @msg = @msg + "（管理者モードでログインされています）"
    end
    if @subsection_cheif
      @recent_practice = Practice.order_practice.where('date >= ?', Date.today).where(kind: 'run_thru').first
    else
      @recent_practice = Practice.order_practice.where('date >= ?', Date.today).first
    end
    @recent_practice_link = "/executive/contacts_list"

    unless @recent_practice.nil?
      @recent_practice_link += "/" + @recent_practice.id.to_s
    end
  end

  def executive_user_list
    @users = ExecutiveUser.all
  end
end
