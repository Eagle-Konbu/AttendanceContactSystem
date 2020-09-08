namespace :check_practice_to_be_notified do
    desc "出欠連絡未提出あるか確かめ，該当すればメール送信"
    task send: :environment do
        practices = Practice.where(date: Date.today + 1.day)
        for practice in practices
            for member in Member.can_receive_email(practice)
                if Contact.find_by(member_id: member.id, practice_id: practice.id).blank?
                    ContactStatusMailer.send_reminder(practice, member).deliver
                end
            end
        end
    end
end
