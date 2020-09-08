class AddAdminToExecutiveUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :executive_users, :admin, :boolean, default: false
  end
end
