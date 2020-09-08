class CreateNumbers < ActiveRecord::Migration[5.2]
  def change
    create_table :numbers do |t|
      t.string :name
      t.integer :leader_member_id_1
      t.integer :leader_member_id_2
      t.integer :leader_member_id_3

      t.timestamps
    end
  end
end
