class CreateRooms < ActiveRecord::Migration[7.0]
  def change
    create_table :rooms do |t|
      t.integer :places_amount, null: false, default: 1
      t.integer :room_class, null: false, default: 0
      t.integer :room_number
      t.boolean :is_free, null: false, default: true
      t.decimal :price, precision: 10, scale: 2, null: false, index: true

      t.timestamps
    end
    add_index :rooms, :room_number, unique: true
  end
end
