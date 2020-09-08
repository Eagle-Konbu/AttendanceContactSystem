class AddFinalReminderAveilableToPractices < ActiveRecord::Migration[5.2]
  def change
    add_column :practices, :finel_reminder_aveilable, :boolean, default: false
  end
end
