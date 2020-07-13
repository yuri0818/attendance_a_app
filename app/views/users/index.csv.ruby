require 'csv'

CSV.generate do |csv|
  column_names = %w(name age Email)
  csv << column_names
  @users.each do |user|
    column_values = [
      user.name,
      user.email,
      user.password_digest,
      user.affiliation,
      user.basic_work_time,
      user.designation_started_at,
      user.designation_finished_at
    ]
    csv << column_values
  end
end