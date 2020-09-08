class AddEmailDeliverTimeToExecutiveUser < ActiveRecord::Migration[5.2]
  def change
    add_column :executive_users, :email_deliver_time, :integer
  end
end
