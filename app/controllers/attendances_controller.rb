class AttendancesController < ApplicationController
   
  before_action :set_user, only: [:edit_one_month, :update_one_month,:overtime_application,:overtime_update,:overtime_log, :overtime_log_update, :superior_info,
  :superior_update]
  before_action :logged_in_user, only: [:update, :edit_one_month, ]
  before_action :admin_or_correct_user, only: [:update, :edit_one_month, :update_one_month]
  before_action :set_one_month, only: [:edit_one_month,  ]

  UPDATE_ERROR_MSG = "勤怠登録に失敗しました。やり直してください。"

    def update
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:id])
    # 出勤時間が未登録であることを判定します。
     if @attendance.started_at.nil?
       if @attendance.update_attributes(_started_at: Time.current.change(sec: 0))
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

    def edit_one_month
    end
  
    def update_one_month
    ActiveRecord::Base.transaction do # トランザクションを開始します。
      attendances_params.each do |id, item|
        attendance = Attendance.find(id)
        attendance.update_attributes!(item)
      end
    end
      flash[:success] = "1ヶ月分の勤怠情報を更新しました。"
      redirect_to user_url(date: params[:date])
    rescue ActiveRecord::RecordInvalid # トランザクションによるエラーの分岐です。
      flash[:danger] = "無効な入力データがあった為、更新をキャンセルしました。"
      redirect_to attendances_edit_one_month_user_url(date: params[:date])
    end
  
    def overtime_application
       @attendance = Attendance.find(params[:day])
       @superior = User.where(superior: true).where.not(id: @user.id)
    end
    
    
    def overtime_update
      @attendance = Attendance.find(params[:id])
      @attendance.overtime_status = "申請中"
      if @attendance.update_attributes(overtime_params)
        flash[:success] = "you applied for overtime " 
        redirect_to user_path @user
      else
        flash[:danger] = "残業申請をキャンセルしました"
        redirect_to user_path @user
      end
    end

    def overtime_log
        @attendance = Attendance.find(params[:id])
    end
   
   
    def overtime_log_update
       @attendance = Attendance.find(params[:id])
       flash[:pink] = "Applied for overtime"
        redirect_to @user 
    end
   
    def superior_info
        @superior = User.where(superior: true).where.not(id: @user.id)
        @overtime_request = Attendance.where(overtime_status: "申請中", instructor_mark: @user.name).order(user_id: "ASC", worked_on: "ASC").group_by(&:user_id)    
    end
    
    def superior_update
      ActiveRecord::Base.transaction do # トランザクションを開始します。
        superior_params.each do |id, item|
          if item[:overtime_status] == "なし" 
            item[:scheduled_end_time] = nil
            item[:designation_finished_at] = nil
            item[:business_content] = nil
            item[:overtime_status] = nil
            item[:change]  = nil
          end 
          attendance = Attendance.find(id)
          attendance.update_attributes!(item)
        end
     end
     flash[:success] = "残業申請を更新しました。"
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

     def overtime_params
       params.require(:attendance).permit(:scheduled_end_time, :tomorrow,:business_content, :instructor_mark )
     end
     
     def superior_params
       params.require(:user).permit(attendances: [:scheduled_end_time, :change, :designation_finished_at,
                                                  :business_content, :overtime_status])[:attendances]
     end
   
end
