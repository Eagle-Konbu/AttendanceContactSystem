class LineGroupForBotsController < ApplicationController
  before_action :set_line_group_for_bot, only: [:show, :edit, :update, :destroy]

  # GET /line_group_for_bots
  # GET /line_group_for_bots.json
  def index
    @line_group_for_bots = LineGroupForBot.all
  end

  # GET /line_group_for_bots/1
  # GET /line_group_for_bots/1.json
  def show
  end

  # GET /line_group_for_bots/new
  def new
    @line_group_for_bot = LineGroupForBot.new
  end

  # GET /line_group_for_bots/1/edit
  def edit
  end

  # POST /line_group_for_bots
  # POST /line_group_for_bots.json
  def create
    @line_group_for_bot = LineGroupForBot.new(line_group_for_bot_params)

    respond_to do |format|
      if @line_group_for_bot.save
        format.html { redirect_to @line_group_for_bot, notice: 'Line group for bot was successfully created.' }
        format.json { render :show, status: :created, location: @line_group_for_bot }
      else
        format.html { render :new }
        format.json { render json: @line_group_for_bot.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /line_group_for_bots/1
  # PATCH/PUT /line_group_for_bots/1.json
  def update
    respond_to do |format|
      if @line_group_for_bot.update(line_group_for_bot_params)
        format.html { redirect_to @line_group_for_bot, notice: 'Line group for bot was successfully updated.' }
        format.json { render :show, status: :ok, location: @line_group_for_bot }
      else
        format.html { render :edit }
        format.json { render json: @line_group_for_bot.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /line_group_for_bots/1
  # DELETE /line_group_for_bots/1.json
  def destroy
    @line_group_for_bot.destroy
    respond_to do |format|
      format.html { redirect_to line_group_for_bots_url, notice: 'Line group for bot was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_line_group_for_bot
      @line_group_for_bot = LineGroupForBot.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def line_group_for_bot_params
      params.require(:line_group_for_bot).permit(:group_id)
    end
end
