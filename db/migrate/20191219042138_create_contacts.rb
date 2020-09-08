class CreateContacts < ActiveRecord::Migration[5.2]
  def change
    create_table :contacts do |t|
      t.integer :member_id
      t.integer :practice_id
      t.integer :status
      t.text :reason

      t.timestamps
    end
  end
end
