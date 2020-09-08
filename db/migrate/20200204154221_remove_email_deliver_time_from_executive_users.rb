class RemoveEmailDeliverTimeFromExecutiveUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :executive_users, :email_deliver_time, :integer
  end
end
