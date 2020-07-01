class CreateOffices < ActiveRecord::Migration[5.1]
  def change
    create_table :offices do |t|
      t.string :office_number
      t.string :office_name 
      t.string :office_type
      
      t.timestamps
    end
  end
end
