class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :affiliation
      t.string :employee_number
      t.string :uid
      t.time   :basic_work_time, default: Time.current.change(hour: 8, min: 0, sec: 0)
      t.time   :designation_started_at, default: Time.current.change(hour: 9, min: 0, sec: 0)  # 指定勤務開始時間 
      t.time   :designation_finished_at, default: Time.current.change(hour: 18, min: 0, sec: 0)  # 指定勤務終了時間   
          
      t.timestamps
    end
  end
end
