class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :employee_number
      t.string :uid
      t.time   :day
      
      t.timestamps
    end
  end
end
