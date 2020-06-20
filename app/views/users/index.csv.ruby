require 'csv'

CSV.generate do |csv|
  column_names = %w(name age Email)
  csv << column_names
  @users.each do |user|
    column_values = [
      user.name,
      user.email,
      user.password_digest,
      user.department,
      user.basic_time,
      user.work_time,
      user.basic_time
    ]
    csv << column_values
  end
end