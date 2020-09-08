class AddNameToExecutiveUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :executive_users, :name, :string
  end
end
