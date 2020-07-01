class CreateAttendances < ActiveRecord::Migration[5.1]
  def change
    create_table :attendances do |t|
      t.date :worked_on
      t.datetime :started_at
      t.datetime :finished_at
      t.string :note
      t.boolean :tomorrow              # 翌日   
      t.datetime :scheduled_end_time      # 終了予定時間
               
      t.datetime :designation_started_at   # 指定勤務開始時間 
      t.datetime :designation_finished_at  # 指定勤務終了時間
                
      t.datetime :before_started_at       # 変更前出社時間
      t.datetime :before_finished_at      # 変更前退社時間
                
      t.datetime :change_started_at       # 変更後出社時間
      t.datetime :change_finished_at      # 変更後出社時間
                
      t.string :instructor               # 指示者
      t.string :authorizer               # 承認者
      t.string :business_content         # 業務処理内容
      t.string :instructo_mark           # 指示者確認印
                
      t.string :overtime_app            # 残業申請　申請中
      t.string :overtime_app_approval   # 残業申請　承認
                
      t.string :overtime_edit_app       # 勤怠編集　申請中
      t.string :overtime_edit_approval  # 勤怠編集  承認
                
      t.string :month_app                #一ヶ月残業申請　申請中
      t.string :month_app_app            #一ヶ月残業申請　承認
                
      t.string :overtime_app_authorizer  # 残業申請 承認者
      t.string :overtime_edit_app_authorizer#勤怠編集 承認者 
      t.string :month_app_app_authorizer #一ヶ月残業申請 承認者
     
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end

