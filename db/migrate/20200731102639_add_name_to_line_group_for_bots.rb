class AddNameToLineGroupForBots < ActiveRecord::Migration[5.2]
  def change
    add_column :line_group_for_bots, :name, :string
  end
end
