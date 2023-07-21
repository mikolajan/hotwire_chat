class CreateRooms < ActiveRecord::Migration[7.0]
  def change
    create_table :rooms do |t|
      t.string  :title,     null: false, index: true
      t.integer :room_type, null: false, default: 0

      t.timestamps
    end
  end
end
