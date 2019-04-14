class CreateThermostats < ActiveRecord::Migration[5.2]
  def change
    create_table :thermostats do |t|
      t.text :household_token
      t.text :address
      t.timestamps  null: false
    end
  end
end
#Address should have a separate model but for sake of simplicity as it is never used I have kept the it in a text field.