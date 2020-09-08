class CreateLineReplyMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :line_reply_messages do |t|
      t.string :detail

      t.timestamps
    end
  end
end
