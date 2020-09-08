class AddNicknameToExecutiveUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :executive_users, :nickname, :string
  end
end
