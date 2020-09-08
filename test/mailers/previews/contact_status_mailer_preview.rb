# Preview all emails at http://localhost:3000/rails/mailers/contact_status_mailer
class ContactStatusMailerPreview < ActionMailer::Preview
    def contact_status_preview
        practice = Practice.find(3)
        user = ExecutiveUser.find(1)

        ContactStatusMailer.send_contact_status_mail(practice, user)
    end
end
