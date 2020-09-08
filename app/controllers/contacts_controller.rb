class ContactsController < ApplicationController
  before_action :authenticate_executive_user!, except: %i[add create check_submitted check_practice_detail after_submitted check_aveilable_practices]
  def practice_list
    @practices = Practice.where('date >= ?', Date.today).order_practice
    @obsolete_practices = Practice.where('date < ?', Date.today).order_practice
  end
  
  def list
    practice = Practice.find(params[:id])
    @title = practice.display_name
    @data = []

    for m in Member.where("created_at <= ?", practice.date.to_time).valid_members(practice).order_member do
      contact_for_nil = Contact.new({member_id: m.id, practice_id: practice.id, status: 5, reason:""})
      @data.push(Contact.where(practice_id: practice.id).find_by(member_id: m.id) || contact_for_nil)
    end

    @min_generation = practice.includes_obog ? Member.minimum(:generation) : 12
    @max_generation = Member.maximum(:generation)
  end

  def add
    @contact = Contact.new
    member_id = params[:default_member_id]
    if member_id.blank?
      @aveilable_practices = Practice.none
    else
      @aveilable_practices = Practice.where('date >= ?', Date.today).can_attend_to(Member.find(member_id)).order_practice
    end
    @generation = params[:generation] || 0
    @members = Member.all

    render layout: false
  end

  def create
    @contact = Contact.new(contact_params)

    @exist_contact = Contact.find_by(member_id: @contact.member_id, practice_id: @contact.practice_id)

    practice = Practice.find(@contact.practice_id)
    practice_date = practice.date

    overdue = (Time.now > Time.new(practice_date.year, practice_date.month, practice_date.day, 12, 0, 0) - 1.day)

    if @contact.save then
      if @exist_contact != nil
        @exist_contact.destroy
      end
      if overdue and @contact.status != 'attend'
        for user in ExecutiveUser.can_receive_email(practice)
          ContactStatusMailer.send_contact_update_mail(@contact, user).deliver_later
        end
        client = Line::Bot::Client.new { |config|
          config.channel_secret = ENV["EXECUTIVE_LINE_SECRET_KEY"]
          config.channel_token = ENV["EXECUTIVE_LINE_TOKEN"]
        }
        updater = Member.find(@contact.member_id)
        practice = Practice.find(@contact.practice_id)

        case @contact.status
        when "attend"
          header_color = "#007b43"
        when "absent"
          header_color = "#c9171e"
        when "late"
          header_color = "#e6b422"
        else
          header_color = "#4c6cb3"
        end
        message = {
          type: "flex",
          altText: updater.display_nickname(true, true) + "が出欠連絡を送信しました（" + @contact.status_i18n + "）",
          contents: {
            "type": "bubble",
            "size": "kilo",
            "header": {
              "type": "box",
              "layout": "vertical",
              "contents": [
                {
                  "type": "box",
                  "layout": "vertical",
                  "contents": [
                    {
                      "type": "text",
                      "text": "出欠連絡を受信",
                      "color": "#ffffff",
                      "size": "xl",
                      "flex": 4,
                      "weight": "bold"
                    }
                  ]
                },
                {
                  "type": "box",
                  "layout": "vertical",
                  "contents": [
                    {
                      "type": "text",
                      "text": "FROM",
                      "color": "#ffffff66",
                      "size": "sm"
                    },
                    {
                      "type": "text",
                      "text": updater.is_obog ? updater.display_nickname(true, true) : updater.display_nickname(true, false),
                      "color": "#ffffff",
                      "size": "md",
                      "weight": "bold"
                    }
                  ]
                }
              ],
              "backgroundColor": header_color,
              "spacing": "md"
            },
            "body": {
              "type": "box",
              "layout": "vertical",
              "contents": [
                {
                  "type": "box",
                  "layout": "horizontal",
                  "contents": [
                    {
                      "type": "text",
                      "text": "練習名",
                      "size": "sm"
                    },
                    {
                      "type": "box",
                      "layout": "vertical",
                      "contents": [
                        {
                          "type": "text",
                          "text": practice.display_short_name,
                          "align": "end",
                          "size": "sm"
                        }
                      ],
                      "width": "75%"
                    }
                  ]
                },
                {
                  "type": "separator",
                  "margin": "md"
                },
                {
                  "type": "box",
                  "layout": "horizontal",
                  "contents": [
                    {
                      "type": "text",
                      "text": "状況",
                      "size": "sm"
                    },
                    {
                      "type": "box",
                      "layout": "vertical",
                      "contents": [
                        {
                          "type": "text",
                          "text": @contact.status_i18n,
                          "align": "end",
                          "size": "sm"
                        }
                      ],
                      "width": "75%"
                    }
                  ],
                  "margin": "md"
                },
                {
                  "type": "box",
                  "layout": "horizontal",
                  "contents": [
                    {
                      "type": "text",
                      "text": "理由",
                      "size": "sm"
                    },
                    {
                      "type": "box",
                      "layout": "vertical",
                      "contents": [
                        {
                          "type": "text",
                          "text": @contact.reason,
                          "align": "end",
                          "size": "sm",
                          "wrap": true
                        }
                      ],
                      "width": "75%"
                    }
                  ],
                  "margin": "md"
                }
              ]
            }
          }
        }
        client.broadcast(message)

      end
      redirect_to contacts_after_submitted_path(contact_params)
    else
      render action: :add, layout: false
    end
  end

  def after_submitted
    contact = params[:contact]
    @member_id = params[:member_id]
    @practice_id = params[:practice_id]

    @practice = Practice.find(@practice_id)

    @unsubmitted_practices = []
    for p in Practice.where('date >= ?', Date.today).can_attend_to(Member.find(@member_id)).order_practice
      if Contact.find_by(practice_id: p.id, member_id: @member_id).blank?
        @unsubmitted_practices.push(p)
      end
    end

    render layout: false
  end

  def check_aveilable_practices
    member_id = params[:default_member_id]
    @contact = Contact.new(member_id: member_id)
    @valid_practices = Practice.where('date >= ?', Date.today).can_attend_to(Member.find(member_id)).order_practice
  end

  def check_submitted
    member_id = params[:member_id]
    practice_id = params[:practice_id]
    if member_id != nil and practice_id != nil
      if Contact.where(member_id: member_id, practice_id: practice_id).count > 0
        status = Contact.find_by(member_id: member_id, practice_id: practice_id).status_i18n
        @alert = "<p class='alert alert-primary'><i class='fa fa-info-circle'></i>　既に「<b>" + status + "</b>」として提出されています。（再提出可能です）</p>"
      else
        @alert = ""
      end
      if Practice.find(practice_id).overdue
        @alert += "<p class='alert alert-warning'><i class='fa fa-exclamation-triangle'></i>　前日12:00を過ぎています。（送信は可能です）</p>"
      end
    else
      @alert = ""
    end
  end

  def check_practice_detail
    practice = Practice.find(params[:practice_id])
    if practice.present?
      @place = practice.place
      @time = practice.start_time.strftime("%H:%M") + "~" + practice.end_time.strftime("%H:%M")
    end
    @place = "N/A" if @place.blank?
    @time = "N/A" if @time.blank?
  end

  private
  def contact_params
    params.require(:contact).permit(:member_id, :practice_id, :status, :reason)
  end
end
