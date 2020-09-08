class AddEncrypedEmailToMember < ActiveRecord::Migration[5.2]
  def change
    add_column :members, :encryped_email, :text
  end
end
