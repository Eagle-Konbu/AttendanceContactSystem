class RemoveIndexEmailFromExecutiveUsers < ActiveRecord::Migration[5.2]
  def up
    remove_index :executive_users, :email
  end

  def down
    add_index :executive_users, :email, unique: true
  end
end
