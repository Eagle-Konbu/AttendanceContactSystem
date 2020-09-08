class RemoveNoticeTimeFromPractices < ActiveRecord::Migration[5.2]
  def change
    remove_column :practices, :notice_time, :time
  end
end
