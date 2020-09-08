class ContactStatusMailer < ApplicationMailer
    def send_contact_status_mail(practice, receiver)
        @practice = practice
        @receiver = receiver
        #0:attend 1:absent 2:late 3:go_early 4:other
        @counts = (0..4).map {|i| Contact.where(status: i, practice_id: @practice.id).count }

        @absent_contacts = Contact.where(status: 1, practice_id: @practice.id).joins(:member).merge(Member.order_member)
        @late_contacts = Contact.where(status: 2, practice_id: @practice.id).joins(:member).merge(Member.order_member)
        @go_early_contacts = Contact.where(status: 3, practice_id: @practice.id).joins(:member).merge(Member.order_member)
        @other_contacts = Contact.where(status: 4, practice_id: @practice.id).joins(:member).merge(Member.order_member)

        @unsubmitted_member = []
        for m in Member.all.order('generation').order_member
            if Contact.where(practice_id: @practice.id).find_by(member_id: m.id).nil?
                @unsubmitted_member.push(m.display_nickname(true,false))
            end
        end

        @min_generation = Member.minimum(:generation)
        @max_generation = Member.maximum(:generation)

        mail(
            from: 'kmmy.executive.contact.system@gmail.com',
            to: @receiver.email,
            subject: practice.display_name + "の出欠状況"
        )
    end

    def send_contact_update_mail(contact, receiver)
        @practice = Practice.find(contact.practice_id)
        @updater = Member.find(contact.member_id)
        @receiver = receiver
        @contact = contact

        mail(
            from: 'kmmy.executive.contact.system@gmail.com',
            to: @receiver.email,
            subject: @updater.nickname + "さんが出欠連絡を送信しました"
        )
    end

    def send_reminder(practice, receiver)
        @practice = practice
        @receiver = receiver

        mail(
            from: 'kmmy.executive.contact.system@gmail.com',
            to: @receiver.email,
            subject: @practice.display_name + "の出欠連絡"
        )
    end
end
