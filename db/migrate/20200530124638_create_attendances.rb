class CreateAttendances < ActiveRecord::Migration[5.1]
  def change
    create_table :attendances do |t|
      t.date :worked_on
      t.datetime :started_at
      t.datetime :finished_at
      t.string :note
      t.boolean :tomorrow                 # 翌日   
      t.datetime :scheduled_end_time      # 終了予定時間
      t.datetime :before_started_at       # 変更前出社時間
      t.datetime :before_finished_at      # 変更前退社時間
      t.datetime :change_started_at       # 変更後出社時間
      t.datetime :change_finished_at      # 変更後出社時間
      t.string :business_content          # 業務処理内容
      t.string :instructor_mark            # 指示者確認印
      t.string :change                     # 変更
                
      t.string :overtime_status           # 残業申請の状態
      t.string :edit_status               # 勤怠編集の状態　
      t.string :month_status              #一ヶ月申請の状態

      t.string :overtime_authorizer  # 残業申請 承認者
      t.string :edit_authorizer      # 勤怠編集 承認者 
      t.string :month_authorizer     # 一ヶ月残業申請 承認者
      t.date   :apporoval_date       # 勤怠編集の承認日
     
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end

