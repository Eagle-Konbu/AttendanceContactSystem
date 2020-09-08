class LineBotController < ApplicationController

    protect_from_forgery :except => [:callback]
    def callback
        body = request.body.read
        signature = request.env['HTTP_X_LINE_SIGNATURE']
        client = Line::Bot::Client.new { |config|
            config.channel_secret = ENV["PUBLIC_LINE_SECRET_KEY"]
            config.channel_token = ENV["PUBLIC_LINE_TOKEN"]
        }
        unless client.validate_signature(body, signature)
            head :bad_request
        end

        events = client.parse_events_from(body)

        events.each do |event|
            case event
            when Line::Bot::Event::Message
            when Line::Bot::Event::Join
                group = LineGroupForBot.new(group_id: event['source']['groupId'])
                group.save!
            when Line::Bot::Event::Leave
                group = LineGroupForBot.find_by(group_id: event['source']['groupId'])
                group.destroy
            end
        end
        head :ok
    end

    def callback_executive
        body = request.body.read
        signature = request.env['HTTP_X_LINE_SIGNATURE']
        client = Line::Bot::Client.new { |config|
            config.channel_secret = ENV["EXECUTIVE_LINE_SECRET_KEY"]
            config.channel_token = ENV["EXECUTIVE_LINE_TOKEN"]
        }
        unless client.validate_signature(body, signature)
            head :bad_request
        end

        events = client.parse_events_from(body)

        events.each do |event|
            case event
            when Line::Bot::Event::Message
                reply(client, event)
            end
        end
        head :ok
    end
    

    def reply(client, event)        
        case event.type
        when Line::Bot::Event::MessageType::Text
            if event.message['text'].include?("死")
                message_text = "俺はまだ死なん！"

                message = {
                    type: "text",
                    text: message_text
                }
                client.reply_message(event['replyToken'], message)
            end
            if event.message['text'] == "出欠連絡概略"
                next_practice_date = Practice.where("date >= ?", Date.today).order_practice.first.date
                next_practices = Practice.where(date: next_practice_date).order(:start_time)
                for p in next_practices
                    client.reply_message(event['replyToken'], p.detail_line_message)
                end
                return nil
            elsif event.message['text'] == "出席者"
                next_practices = Practice.where('date >= ?', Date.today).order_practice
                for p in next_practices
                    message_text = "【" + p.display_short_name + "の出席者】\n提出時間降順で表示\n\n"
                    count = 0
                    #0:attend 1:absent 2:late 3:go_early 4:other
                    for contact in Contact.where(status: 0, practice_id: p.id).order(created_at: :desc)
                        member = Member.find(contact.member_id)
                        message_text += member.display_nickname(true, member.is_obog) + "\n"
                        count += 1
                    end
                    message_text += "\n以上" + count.to_s + "名"

                    message = {
                        type: "text",
                        text: message_text
                    }
                    client.reply_message(event['replyToken'], message)
                end
            elsif event.message['text'] == "遅刻者"
                next_practices = Practice.where('date >= ?', Date.today).order_practice
                for p in next_practices
                    message_text = "【" + p.display_short_name + "の遅刻者】\n提出時間降順で表示\n\n"
                    count = 0
                    #0:attend 1:absent 2:late 3:go_early 4:other
                    for contact in Contact.where(status: 2, practice_id: p.id).order(created_at: :desc)
                        member = Member.find(contact.member_id)
                        message_text += member.display_nickname(true, member.is_obog) + "\n"
                        count += 1
                    end
                    message_text += "\n以上" + count.to_s + "名"

                    message = {
                        type: "text",
                        text: message_text
                    }
                    client.reply_message(event['replyToken'], message)
                end
            elsif event.message['text'] == "欠席者"
                next_practices = Practice.where('date >= ?', Date.today).order_practice
                for p in next_practices
                    message_text = "【" + p.display_short_name + "の欠席者】\n提出時間降順で表示\n\n"
                    count = 0
                    #0:attend 1:absent 2:late 3:go_early 4:other
                    for contact in Contact.where(status: 1, practice_id: p.id).order(created_at: :desc)
                        member = Member.find(contact.member_id)
                        message_text += member.display_nickname(true, member.is_obog) + "\n"
                        count += 1
                    end
                    message_text += "\n以上" + count.to_s + "名"

                    message = {
                        type: "text",
                        text: message_text
                    }
                    client.reply_message(event['replyToken'], message)
                end
            else
                message_text = LineReplyMessage.where('id >= ?', rand(LineReplyMessage.first.id..LineReplyMessage.last.id)).first.detail
                message = {
                    type: "text",
                    text: message_text
                }
                client.reply_message(event['replyToken'], message)
            end
        end
    end
end
