class CreatePractices < ActiveRecord::Migration[5.2]
  def change
    create_table :practices do |t|
      t.text :name
      t.date :date

      t.timestamps
    end
  end
end
