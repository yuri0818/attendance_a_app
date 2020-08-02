module AttendancesHelper

  def attendance_state(attendance)
    # 受け取ったAttendanceオブジェクトが当日と一致するか評価します。
    if Date.current == attendance.worked_on
      return '出勤' if attendance.started_at.nil?
      return '退勤' if attendance.started_at.present? && attendance.finished_at.nil?
    end
    # どれにも当てはまらなかった場合はfalseを返します。
    return false
  end

  # 出勤時間と退勤時間を受け取り、在社時間を計算して返します。
  def working_times(start, finish, tomorrow)
    if tomorrow == true
      format("%.2f", (((finish - start) / 60) / 60.0) + 24)
    else
      format("%.2f", (((finish - start) / 60) / 60.0))  
    end    
  end
  # 指定勤務終了時間と終了予定時間を受け取り、時間外時間を計算して返します。
  def over_times(tomorrow, scheduled_end_time, designation_finished_at, started_at)
    if (started_at.present? && scheduled_end_time.present?) && 
      ((designation_finished_at.hour < started_at.hour) || 
      ((designation_finished_at.hour == started_at.hour) && (designation_finished_at.min < started_at.min)))
      if tomorrow == true
       format("%.2f", (((( designation_finished_at.hour-started_at.hour) * 60) + 
                     (designation_finished_at.min-started_at.min)) / 60.0) + 24)
       else
       format("%.2f", ((((designation_finished_at.hour-started_at.hour) * 60) +
                     (designation_finished_at.min-started_at.min)) / 60.0)) 
       end
     else
      if tomorrow == true
       format("%.2f", ((((scheduled_end_time.hour - designation_finished_at.hour) * 60) + 
                     (scheduled_end_time.min - designation_finished_at.min)) / 60.0) + 24)
      else
       format("%.2f", ((((scheduled_end_time.hour - designation_finished_at.hour) * 60) +
                     (scheduled_end_time.min - designation_finished_at.min)) / 60.0)) 
      end
    end 
   end
  
  
  
  def format_hour(time)
      format("%02d", (time.hour))
  end


  def format_min(time)
      format("%02d", (time.min / 15 * 15 ))
  end
  
end