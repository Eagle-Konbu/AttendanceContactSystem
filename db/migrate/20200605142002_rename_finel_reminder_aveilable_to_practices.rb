class RenameFinelReminderAveilableToPractices < ActiveRecord::Migration[5.2]
  def change
    rename_column :practices, :finel_reminder_aveilable, :final_reminder_aveilable
  end
end
