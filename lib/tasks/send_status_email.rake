namespace :send_status_email do
    desc "出欠状況メール送信"
    task send: :environment do
        practices = Practice.all.where(date: Date.today + 1.day)

        for p in practices
            for user in ExecutiveUser.can_receive_email(p)
                ContactStatusMailer.send_contact_status_mail(p, user).deliver
            end
            
            client = Line::Bot::Client.new { |config|
                config.channel_secret = ENV["EXECUTIVE_LINE_SECRET_KEY"]
                config.channel_token = ENV["EXECUTIVE_LINE_TOKEN"]
            }
    
            response = client.broadcast(p.detail_line_message)
        end
    end
end
