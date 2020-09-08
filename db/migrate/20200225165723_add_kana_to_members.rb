class AddKanaToMembers < ActiveRecord::Migration[5.2]
  def change
    add_column :members, :first_kana, :string
    add_column :members, :last_kana, :string
  end
end
