class RenameSendEmailColumnToExecutiveUsers < ActiveRecord::Migration[5.2]
  def change
    rename_column :executive_users, :send_email, :receive_email
  end
end
