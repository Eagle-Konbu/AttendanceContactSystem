class AddStartTimeToPractices < ActiveRecord::Migration[5.2]
  def change
    add_column :practices, :start_time, :time
  end
end
