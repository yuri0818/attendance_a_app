require 'csv'

CSV.generate do |csv|
  csv_column_names = %w(Firstname Lastname Email)
  csv << csv_column_names
  @users.each do |user|
    csv_column_values = [
      user.firstname,
      user.lastname,
      user.email
    ]
    csv << csv_column_values
     end
     
     
    respond_to do |format|
  format.csv do
    send_data render_to_string, filename: "hoge.csv", type: :csv
  end
end 
     
     
end