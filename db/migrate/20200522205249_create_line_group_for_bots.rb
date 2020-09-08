class CreateLineGroupForBots < ActiveRecord::Migration[5.2]
  def change
    create_table :line_group_for_bots do |t|
      t.string :group_id
      t.boolean :send_message, default: false

      t.timestamps
    end
  end
end
