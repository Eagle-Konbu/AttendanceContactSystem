class AddNoticeTimeToPractices < ActiveRecord::Migration[5.2]
  def change
    add_column :practices, :notice_time, :time
  end
end
