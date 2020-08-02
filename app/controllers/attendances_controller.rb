class AttendancesController < ApplicationController
   
  before_action :set_user, only: [:edit_one_month, :update_one_month,:overtime_application,
                                  :overtime_log, :overtime_log_update, :superior_info,
                                  :superior_update,:timetable_edit_update,
                                  :request_one_update,:notices_one,:notices_one_update]
  before_action :logged_in_user, only: [:update, :edit_one_month ]
  before_action :admin_or_correct_user, only: [:update, :edit_one_month, :update_one_month]
  before_action :set_one_month, only: [:edit_one_month,  ]

  UPDATE_ERROR_MSG = "勤怠登録に失敗しました。やり直してください。"

    def update
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:id])
    # 出勤時間が未登録であることを判定します。
     if @attendance.started_at.nil?
       if @attendance.update_attributes(started_at: Time.current.change(sec: 0))
         flash[:info] = "おはようございます！"
       else
         flash[:danger] = UPDATE_ERROR_MSG
       end
     elsif @attendance.finished_at.nil?
      if @attendance.update_attributes(finished_at: Time.current.change(sec: 0))
        flash[:info] = "お疲れ様でした。"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
     end
     redirect_to @user
    end

    def edit_one_month            # 勤怠変更申請　社員側 表示
      @attendance = Attendance.find(params[:id])
      @superior = User.where(superior: true).where.not(id: @user.id) #自分以外の上長表示
    end
  
    def update_one_month   # one_month_edit_params
    ActiveRecord::Base.transaction do # トランザクションを開始します。　# 勤怠変更申請　社員側
      one_month_edit_params.each do |id, item|
        if (item[:change_tomorrow] == "0") && (item[:change_started_at] > item[:change_finished_at])
          flash[:danger] = "無効な入力データがあった為、更新をキャンセルしました。"
          redirect_to attendances_edit_one_month_user_url(date: params[:date]) and return
        end
                # 状態カラム                       #   編集用出社時間                   #編集用退社時間
        if item[:edit_authorizer].present? && item[:change_started_at].present? && item[:change_finished_at].present?
          # 変更後の変更後出勤 退勤時間あれば更新可能
          attendance = Attendance.find(id)
          attendance.edit_status = "申請中" # ここで:edit_statusに"申請中" いれてshowで拾って@edit_status_countで表示
          attendance.update_attributes!(item)
        end
      end
    end
      flash[:success] = "1ヶ月分の勤怠情報を更新しました。"
      redirect_to user_url(date: params[:date])
    rescue ActiveRecord::RecordInvalid # トランザクションによるエラーの分岐です。
      flash[:danger] = "無効な入力データがあった為、更新をキャンセルしました。"
      redirect_to attendances_edit_one_month_user_url(date: params[:date]) and return
    end
  
    def overtime_application        # 残業申請　社員 表示
       @attendance = Attendance.find(params[:day])
       @superior = User.where(superior: true).where.not(id: @user.id)
       #　viewで@superiorで自分以外の上長表示するためのインスタンス変数　
    end
    
    
    def overtime_update              # 残業申請  社員 から 上長へupdate
      @user = User.find(params[:user_id])
      @attendance = Attendance.find(params[:id])
      # ここで:edit_statusに"申請中"をいれてshowで拾って@overtime_countで表示
      @attendance.overtime_status = "申請中" 
      if @attendance.update_attributes(overtime_params) # 
        flash[:success] = "you applied for overtime " 
        redirect_to user_path @user
      else
        flash[:danger] = "残業申請をキャンセルしました"
        redirect_to user_path @user
      end
    end

   
    def superior_info                    # 残業申請   上長側 表示
        @overtime_request = Attendance.where(overtime_status: "申請中", 
        overtime_authorizer: @user.name).order(user_id: "ASC", worked_on: "ASC").group_by(&:user_id)
         # "申請中"のovertime_status:を探して worked_on:の早い順に表示
    end
    
    def superior_update                          # 残業申請 上長側  更新
      ActiveRecord::Base.transaction do # トランザクションを開始します。
        superior_params.each do |id, item|
          if item[:overtime_change]  == "1"
            if item[:overtime_status] == "なし"  
             　 item[:scheduled_end_time] = nil
            　  item[:designation_finished_at] = nil
            　 item[:business_content] = nil
             　 item[:overtime_status] = nil
               item[:change]  = nil
            if item[:overtime_status] == "否認"
               flash[:success] = "申請を否認しました。"
               redirect_to @user 
              end 
            end 
            attendance = Attendance.find(id)
            attendance.update_attributes!(item)
          end 
        end
     end
     flash[:success] = "残業申請を更新しました。"
     redirect_to @user
    rescue ActiveRecord::RecordInvalid # トランザクションによるエラーの分岐です。
      flash[:danger] = "無効な入力データがあった為、更新をキャンセルしました。"
      redirect_to @user
    end 

    def timetable_edit  # 勤怠変更申請   上長側 表示
      @user = User.find(params[:id])
      @app_edit = Attendance.where(edit_status: "申請中", edit_authorizer: @user.name).
      order(user_id: "ASC", worked_on: "ASC").group_by(&:user_id) 
      #  Attendance.where(edit_status: "申請中"で見つけてくれて表示できる
      #  :edit_authorizer  @user.name).でログインしているuserが上長の場合AかBを表示
      #  :edit_authorizer = 勤怠編集 承認者 
    end
  
    def timetable_edit_update            # 勤怠変更申請  上長側  更新
      ActiveRecord::Base.transaction do # トランザクションを開始します。
        timetable_edit_params.each do |id, item|
          if (item[:change_tomorrow] == "0") && (item[:change_started_at] > item[:change_finished_at])
            flash[:danger] = "無効な入力データがあった為、更新をキャンセルしました。"
            redirect_to @user and return
          end
          attendance = Attendance.find(id)
          if item[:change]  == "1"            # 変更
           if item[:edit_status]  == "承認"
             if attendance.before_started_at.blank?
                attendance.before_started_at = attendance.started_at
             end
             if attendance.before_finished_at.blank?
                attendance.before_finished_at = attendance.finished_at
             end
             item[:started_at] =  attendance.change_started_at
             item[:finished_at] = attendance.change_finished_at
             attendance.apporoval_date = Date.current
           end
           if item[:edit_status] == "なし"   #  残業申請の状態
             　 item[:started_at] = nil        #  出社時間
            　  item[:finished_at] = nil       #  退社時間
            　 item[:note] = nil              #  備考
             　 item[:change_started_at] = nil # 編集用出社時間
               item[:change_finished_at]  = nil # 編集用退社時間
               item[:edit_authorizer]  = nil   #  残業申請 承認者
           end 
            attendance.update_attributes!(item)
          end 
        end
     end
     flash[:success] = "勤怠変更申請を更新しました。"
     redirect_to @user
    rescue ActiveRecord::RecordInvalid # トランザクションによるエラーの分岐です。
      flash[:danger] = "無効な入力データがあった為、更新をキャンセルしました。"
      redirect_to @user and return
    end 
    
    def request_one_update   # 一ヶ月申請  社員 から 上長へupdate
     #一日分を拾う　：dayはパラメーターの名前　show viewで
      @attendance = @user.attendances.find_by(worked_on: params[:user][:day])
      # ここで:edit_statusに"申請中"をいれてshowで拾って@overtime_countで表示
      params[:user][:month_status] = "申請中" 
      if @attendance.update_attributes(notices_one_params) 
        flash[:success] = "you applied for application one_month " 
        redirect_to user_path @user
      else
        flash[:danger] = "一ヶ月申請をキャンセルしました"
        redirect_to user_path @user
      end
    end
    
    def notices_one         # 一ヶ月申請
       @notices_one_request = Attendance.where(month_status: "申請中", 
        month_authorizer: @user.name).order(user_id: "ASC", worked_on: "ASC").group_by(&:user_id)
    end
    
    def notices_one_update  # 一ヶ月申請
      ActiveRecord::Base.transaction do # トランザクションを開始します。
        notices_one_update_params.each do |id, item|
          attendance = Attendance.find(id)
          if item[:one_month_change]  == "1"            # 一ヶ月申請 変更
            if item[:month_status] == "なし"   # 一ヶ月 申請の状態
              attendance.month_authorizer = nil
              item[:month_status] = nil
              item[:one_month_change] = "0"
            end 
            attendance.update_attributes!(item)
          end 
        end
      end
      flash[:success] = "一ヶ月変更申請を更新しました。"
      redirect_to @user
    rescue ActiveRecord::RecordInvalid # トランザクションによるエラーの分岐です。
      flash[:danger] = "無効な入力データがあった為、更新をキャンセルしました。"
      redirect_to @user
    end
   
    private

    # 1ヶ月分の勤怠情報を扱います。
     def attendances_params
      params.require(:user).permit(attendances: [:started_at, :finished_at,:note])[:attendances]
     end

    # beforeフィルター

    # 管理権限者、または現在ログインしているユーザーを許可します。
     def admin_or_correct_user
      @user = User.find(params[:user_id]) if @user.blank?
      unless current_user?(@user) || current_user.admin?
        flash[:danger] = "You do not have edit permission."
        redirect_to(root_url)
      end  
     end

     # 残業申請  社員 から 上長へupdate
     def overtime_params             
       params.require(:attendance).permit(:scheduled_end_time, 
                                          :tomorrow,
                                          :business_content, 
                                          :overtime_authorizer )
     end
      # 残業申請 上長側  更新
     def superior_params
       params.require(:user).permit(attendances: [:scheduled_end_time, 
                                                  :designation_finished_at,
                                                  :overtime_change,
                                                  :business_content, 
                                                  :overtime_status])[:attendances]
     end
    # 勤怠変更申請  社員 から 上長へupdate
     def one_month_edit_params
       params.require(:user).permit(attendances: [:change_started_at, 
                                                  :change_finished_at,
                                                  :change_tomorrow,
                                                  :note, 
                                                  :edit_authorizer ])[:attendances]
     end

     # 勤怠変更申請  上長側  更新
     def timetable_edit_params
       params.require(:user).permit(attendances: [:started_at,                      #  
                                                  :finished_at,                     # 
                                                  :change_started_at,                # 
                                                  :change_finished_at,                #    
                                                  :note,                              #  
                                                  :change,                            # 
                                                  :edit_status ])[:attendances]  # 状態カラム
     end
     
     # 一ヶ月申請  社員 から 上長へupdate?
     def request_one_params
      params.require(:user).permit(attendances: [:started_at,
                                                 :finished_at,
                                                 :note])[:attendances]
     end
    
      # 一ヶ月申請  社員 から 上長へupdate
     def notices_one_params 
       params.require(:user).permit(:month_authorizer, :month_status)
     end
     
     def notices_one_update_params  #一ヶ月申請 上長側  更新
       params.require(:user).permit(attendances: [:one_month_change, :month_status])[:attendances]
     end
     
      
      #カラムは「承認/否認を行うチェックボックス」「日付」「曜日」「出勤」「退勤」「変更理由（DBにカラム追加が必要
     
end
