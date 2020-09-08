class LineReplyMessagesController < ApplicationController
  before_action :set_line_reply_message, only: [:show, :edit, :update, :destroy]

  # GET /line_reply_messages
  # GET /line_reply_messages.json
  def index
    @line_reply_messages = LineReplyMessage.all
  end

  # GET /line_reply_messages/1
  # GET /line_reply_messages/1.json
  def show
  end

  # GET /line_reply_messages/new
  def new
    @line_reply_message = LineReplyMessage.new
  end

  # GET /line_reply_messages/1/edit
  def edit
  end

  # POST /line_reply_messages
  # POST /line_reply_messages.json
  def create
    @line_reply_message = LineReplyMessage.new(line_reply_message_params)

    respond_to do |format|
      if @line_reply_message.save
        format.html { redirect_to @line_reply_message, notice: 'Line reply message was successfully created.' }
        format.json { render :show, status: :created, location: @line_reply_message }
      else
        format.html { render :new }
        format.json { render json: @line_reply_message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /line_reply_messages/1
  # PATCH/PUT /line_reply_messages/1.json
  def update
    respond_to do |format|
      if @line_reply_message.update(line_reply_message_params)
        format.html { redirect_to @line_reply_message, notice: 'Line reply message was successfully updated.' }
        format.json { render :show, status: :ok, location: @line_reply_message }
      else
        format.html { render :edit }
        format.json { render json: @line_reply_message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /line_reply_messages/1
  # DELETE /line_reply_messages/1.json
  def destroy
    @line_reply_message.destroy
    respond_to do |format|
      format.html { redirect_to line_reply_messages_url, notice: 'Line reply message was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_line_reply_message
      @line_reply_message = LineReplyMessage.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def line_reply_message_params
      params.require(:line_reply_message).permit(:detail)
    end
end
