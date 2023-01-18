class AddPriceToBills < ActiveRecord::Migration[7.0]
  def change
    add_monetize :bills, :price
  end
end
