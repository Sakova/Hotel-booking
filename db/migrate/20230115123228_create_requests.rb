class CreateRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :requests do |t|
      t.integer :places_amount, null: false
      t.integer :room_class, default: 0, null: false
      t.datetime :stay_time_from, null: false
      t.datetime :stay_time_to, null: false
      t.text :comment
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
