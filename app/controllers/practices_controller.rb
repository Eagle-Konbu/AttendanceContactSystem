class PracticesController < ApplicationController
  before_action :set_practice, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_executive_user!

  # GET /practices
  # GET /practices.json
  def index
    @practices = Practice.all.order_practice
  end

  # GET /practices/1
  # GET /practices/1.json
  def show
  end

  # GET /practices/new
  def new
    if Practice.count != 0
      latest_practice = Practice.order(:created_at).last
      default_start_time = latest_practice.start_time
      default_end_time = latest_practice.end_time
    else
      default_start_time = Time.now
      default_end_time = Time.now
    end
    
    @practice = Practice.new(final_reminder_aveilable: true, start_time: default_start_time, end_time: default_end_time)
  end

  # GET /practices/1/edit
  def edit
  end

  # POST /practices
  # POST /practices.json
  def create
    @practice = Practice.new(practice_params)

    if @practice.name == nil or @practice.name == ""
      @practice.name = @practice.default_name
    end

    respond_to do |format|
      if @practice.save
        format.html { redirect_to executive_practices_path }
        format.json { render :show, status: :created, location: @practice }
      else
        format.html { render :new }
        format.json { render json: @practice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /practices/1
  # PATCH/PUT /practices/1.json
  def update
    @practice.assign_attributes(practice_params)

    if @practice.name == nil or @practice.name == ""
      @practice.name = @practice.default_name
    end

    respond_to do |format|
      if @practice.save
        format.html { redirect_to executive_practices_path }
        format.json { render :show, status: :ok, location: @practice }
      else
        format.html { render :edit }
        format.json { render json: @practice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /practices/1
  # DELETE /practices/1.json
  def destroy
    @practice.destroy
    respond_to do |format|
      format.html { redirect_to practices_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_practice
      @practice = Practice.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def practice_params
      params.require(:practice).permit(:name, :kind, :date, :start_time, :end_time, :notice_before, :place, :includes_obog, :belonging, :final_reminder_aveilable)
    end
end
