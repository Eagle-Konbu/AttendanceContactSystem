class AddEndTimeToPractices < ActiveRecord::Migration[5.2]
  def change
    add_column :practices, :end_time, :time
  end
end
