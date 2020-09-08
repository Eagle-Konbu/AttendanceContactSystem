namespace :send_reminder_line do
    desc "LINEでリマインド送信"
    task send: :environment do
        client = Line::Bot::Client.new { |config|
            config.channel_secret = ENV["PUBLIC_LINE_SECRET_KEY"]
            config.channel_token = ENV["PUBLIC_LINE_TOKEN"]
        }
        
        practices = Practice.where(date: Date.today + 1.day)
        unsubmitted_count = 0
        for p in practices
            for m in Member.all.order('generation').order_member
                if Contact.where(practice_id: p.id).find_by(member_id: m.id).nil?
                    unsubmitted_count += 1
                end
            end
        end

        practices_text = ""
        for p in practices
            practices_text += "・" + p.display_name + "\n"
        end
        practices_text = practices_text.chop

        header_color = "#b94047"
        rate_color = "#891017"
        unsubmitted_rate = 1 - unsubmitted_count.to_f / (Member.count * practices.count)

        if unsubmitted_rate >= 0.8
            header_color = "#007bbb"
            rate_color = "#005b9b"
        end

        unsubmitted_rate_text = (unsubmitted_rate * 100).round(1).to_s + "%"

        unless practices.blank? and unsubmitted_count != 0
            message = {
                type: "flex",
                altText: "出欠連絡をお忘れなく！",
                contents: {
                    type: "bubble",
                    size: "giga",
                    header: {
                      type: "box",
                      layout: "vertical",
                      contents: [
                        {
                          type: "text",
                          text: "出欠連絡提出をお忘れなく！",
                          size: "xl",
                          color: "#FFFFFF",
                          weight: "bold",
                          decoration: "none",
                          align: "center"
                        },
                        {
                            type: "text",
                            text: "提出率:" + unsubmitted_rate_text + "（" + Time.now.strftime("%-m月%-d日 %H:%M") + "現在）",
                            size: "sm",
                            color: "#FFFFFF",
                            margin: "lg"
                        },
                        {
                            type: "box",
                            layout: "vertical",
                            contents: [
                              {
                                type: "box",
                                layout: "vertical",
                                contents: [
                                  {
                                    type: "filler"
                                  }
                                ],
                                width: unsubmitted_rate_text,
                                height: "6px",
                                backgroundColor: rate_color
                            }
                            ],
                            width: "100%",
                            height: "6px",
                            backgroundColor: "#FFFFFF22",
                            margin: "md"
                        }
                        ]
                    },
                    body: {
                      type: "box",
                      layout: "vertical",
                      contents: [
                        {
                          type: "text",
                          text: "期限は本日の12:00までです！\n"
                        },
                        {
                          type: "text",
                          text: practices_text
                        }
                      ]
                    },
                    footer: {
                      type: "box",
                      layout: "vertical",
                      contents: [
                        {
                          type: "button",
                          action: {
                            type: "uri",
                            label: "提出はコチラから",
                            uri: "https://kmmy-organize-system.herokuapp.com/contacts/add"
                          }
                        }
                      ]
                    },
                    styles: {
                      header: {
                        backgroundColor: header_color,
                        separator: false
                      },
                      hero: {
                        separator: false
                      }
                    }
                }
            }
            for group in LineGroupForBot.where(send_message: true)
              response = client.push_message(group.group_id, message)
            end
        end
    end
end
