require 'csv'

CSV.generate do |csv|
  csv_column_names = ["日付","曜日","出社時間","退社時間"]
  csv << csv_column_names
  @attendances.each do |day|
    csv_column_values = [
      day.worked_on.wday,
      $days_of_the_week[day.worked_on.wday],
      if day.started_at.present?
        l(day.started_at, format: :time)
      else
        ""
      end, 
      if day.finished_at.present?
        l(day.finished_at, format: :time)
      else
        ""
      end  
    ]
    csv << csv_column_values
     end
end