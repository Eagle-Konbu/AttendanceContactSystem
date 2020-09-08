class CreateMembers < ActiveRecord::Migration[5.2]
  def change
    create_table :members do |t|
      t.text :first_name
      t.text :last_name
      t.text :nickname
      t.integer :generation

      t.timestamps
    end
  end
end
