class CreateReadings < ActiveRecord::Migration[5.2]
  def change
    create_table :readings do |t|
      t.belongs_to :thermostat, index: true
      t.integer :number, index: true
      t.decimal :temperature
      t.decimal :humidity
      t.decimal :battery_charge
      t.timestamps  null: false
    end
  end
end
