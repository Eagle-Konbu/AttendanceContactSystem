class RenameNameColumnToExecutiveUsers < ActiveRecord::Migration[5.2]
  def change
    rename_column :executive_users, :name, :user_id
  end
end
