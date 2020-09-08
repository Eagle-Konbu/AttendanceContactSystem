class MembersController < ApplicationController
  before_action :set_member, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_executive_user!

  # GET /members
  # GET /members.json
  def index
    @members = Member.all.order_member
  end

  # GET /members/1
  # GET /members/1.json
  def show
    @practices = Practice.all.order(date: "DESC").where(date: (@member.created_at.to_date)..(Date.today))

    @recent_practice = @practices.first

    #0:attend 1:absent 2:late 3:go_early 4:other 5:unknown
    @counts = [0,0,0,0,0,0]

    for p in @practices do
      if Contact.find_by(member_id: @member.id, practice_id: p.id) == nil then
        @counts[5] += 1
      else
        @counts[Contact.find_by(member_id: @member.id, practice_id: p.id).status_before_type_cast] += 1
      end
    end
  end

  # GET /members/new
  def new
    @member = Member.new
  end

  # GET /members/1/edit
  def edit
  end

  # POST /members
  # POST /members.json
  def create
    @member = Member.new(member_params)
    @member.first_kana = @member.first_kana.tr('ぁ-ん','ァ-ン')
    @member.last_kana = @member.last_kana.tr('ぁ-ん','ァ-ン')

    respond_to do |format|
      if @member.save
        format.html { redirect_to executive_members_path }
        format.json { render :show, status: :created, location: @member }
      else
        format.html { render :new }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /members/1
  # PATCH/PUT /members/1.json
  def update
    @member.assign_attributes(member_params)
    @member.first_kana = @member.first_kana.tr('ぁ-ん','ァ-ン')
    @member.last_kana = @member.last_kana.tr('ぁ-ん','ァ-ン')

    respond_to do |format|
      if @member.save
        format.html { redirect_to executive_members_path }
        format.json { render :show, status: :ok, location: @member }
      else
        format.html { render :edit }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /members/1
  # DELETE /members/1.json
  def destroy
    @member.destroy
    respond_to do |format|
      format.html { redirect_to executive_members_path }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_member
      @member = Member.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def member_params
      params.require(:member).permit(:first_name, :last_name, :first_kana, :last_kana, :nickname, :generation, :leave_on_absence)
    end
end
