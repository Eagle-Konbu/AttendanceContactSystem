namespace :final_reminder do
    desc "最終リマインド送信"
    task send: :environment do
        client = Line::Bot::Client.new { |config|
            config.channel_secret = ENV["PUBLIC_LINE_SECRET_KEY"]
            config.channel_token = ENV["PUBLIC_LINE_TOKEN"]
        }

        #3h ago
        target_hour = Time.now.hour + 3

        for p in Practice.where(date: Date.today).where(final_reminder_aveilable: true)
            if p.start_time.hour == target_hour
                for group in LineGroupForBot.where(send_message: true)
                    response = client.push_message(group.group_id, p.final_reminder_message)
                    print response
                end
            end
        end
    end
end
