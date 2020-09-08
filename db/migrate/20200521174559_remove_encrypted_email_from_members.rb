class RemoveEncryptedEmailFromMembers < ActiveRecord::Migration[5.2]
  def change
    remove_column :members, :encryped_email, :text
  end
end
