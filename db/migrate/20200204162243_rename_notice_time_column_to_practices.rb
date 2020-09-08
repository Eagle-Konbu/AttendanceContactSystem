class RenameNoticeTimeColumnToPractices < ActiveRecord::Migration[5.2]
  def change
    rename_column :practices, :notice_time, :notice_before
  end
end
