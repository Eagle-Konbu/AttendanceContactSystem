class AddNoticeAtToPractices < ActiveRecord::Migration[5.2]
  def change
    add_column :practices, :notice_time, :integer
  end
end
