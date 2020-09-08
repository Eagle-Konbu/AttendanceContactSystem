class RemoveNoticeBeforeFromPractices < ActiveRecord::Migration[5.2]
  def change
    remove_column :practices, :notice_before, :integer
  end
end
