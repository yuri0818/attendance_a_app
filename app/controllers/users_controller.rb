class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info,:attendance_index,
                                 :status_info, :overtime_log]
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :edit_basic_info, :update_basic_info,:import]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:index,:destroy, :edit_basic_info, :update_basic_info,:attendance_index]
  before_action :set_one_month, only: [:show,:status_info]
  before_action :superior_or_correct_user,only: :show
  before_action :admin_or_correct_user,only: :show 
    def index
    @users = User.paginate(page: params[:page])
    end

   def show
     @worked_sum = @attendances.where.not(started_at: nil).count
     #  残業申請カウント
     @overtime_count = Attendance.where(overtime_authorizer: @user.name, overtime_status: "申請中").count 
     #  勤怠申請カウント
     @edit_status_count = Attendance.where(edit_authorizer: @user.name, edit_status: "申請中").count  
     # 一ヶ月申請申請カウント
     @month_status_count = Attendance.where(month_authorizer: @user.name, month_status: "申請中").count 
     @superior = User.where(superior: true).where.not(id: @user.id)
    # @first_day = Date.current.beginning_of_month
    # @last_day = @first_day.end_of_month
      respond_to do |format|
        format.html do
            #html用の処理を書く
        end 
        format.csv do
           send_data render_to_string, filename: "勤怠A.csv", type: :csv #csv用の処理を書く
        end
      end
   end
 
  def import
      User.import(params[:file])
       redirect_to users_url
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = 'Successfully created new'
      redirect_to @user
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Updated user information."
      redirect_to @user
    else
      render :edit      
    end
  end

  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}Deleted the data."
    redirect_to users_url
  end

  def edit_basic_info
  end

  def update_basic_info
    if @user.update_attributes(user_params)
      flash[:success] = "#{@user.name}Updated basic information"
    else
      flash[:danger] = "#{@user.name}の更新は失敗しました。<br>" + @user.errors.full_messages.join("<br>")
    end
    redirect_to users_url
  end
  
  def attendance_index
      @users = User.all.includes(:attendances)
      Attendance.where.not(started_at: nil)
  end
    
  
  def status_info
    @first_day = params[:date].nil? ?
    Date.current.beginning_of_month : params[:date].to_date.beginning_of_month
    @last_day = @first_day.end_of_month
    @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)
    @worked_sum = @attendances.where.not(started_at: nil).count
  end
   
   def overtime_log
     if params["year(1i)"].nil?
        @first_day =  Date.current.beginning_of_month #該当月の初日
     else 
       select_day = params["year(1i)"] + "-" + 
         format("%02d", params["month(2i)"]) + "-" + 
         format("%02d", params["month(3i)"]) 
       @first_day = select_day.to_date.beginning_of_month
     end 
     @last_day = @first_day.end_of_month
     @attendances = @user.attendances.where(edit_status: "承認", worked_on: @first_day..@last_day).order(:worked_on)
   end
  
  private

    def user_params
      params.require(:user).permit(:name, :email, :affiliation, :password, :password_confirmation, :uid, :employee_number )
    end

    def basic_info_params
      params.require(:user).permit(:department, :basic_time, :work_time)
    end
end 
