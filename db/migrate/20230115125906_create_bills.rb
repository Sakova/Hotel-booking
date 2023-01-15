class CreateBills < ActiveRecord::Migration[7.0]
  def change
    create_table :bills do |t|
      t.references :user, null: false, foreign_key: true
      t.references :request, null: false, foreign_key: true
      t.references :room, foreign_key: true

      t.timestamps
    end
  end
end
