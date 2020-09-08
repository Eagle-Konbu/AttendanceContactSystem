class AddLeaveOnAbsenceToMembers < ActiveRecord::Migration[5.2]
  def change
    add_column :members, :leave_on_absence, :boolean, default: false
  end
end
