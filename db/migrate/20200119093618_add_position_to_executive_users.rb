class AddPositionToExecutiveUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :executive_users, :position, :integer, default: 0
  end
end
