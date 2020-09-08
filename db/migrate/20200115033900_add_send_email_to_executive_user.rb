class AddSendEmailToExecutiveUser < ActiveRecord::Migration[5.2]
  def change
    add_column :executive_users, :send_email, :boolean, default: false
  end
end
