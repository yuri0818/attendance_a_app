Rails.application.routes.draw do
  root 'static_pages#top'
  get '/signup', to: 'users#new'

  # ログイン機能
  get    '/login', to: 'sessions#new'
  post   '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :users do
    member do
      get 'edit_basic_info'
      patch 'update_basic_info'
      get 'attendances/edit_one_month'
      patch 'attendances/update_one_month'
      get 'attendances/overtime_application'
      get 'overtime_log'
      get  'attendance_index'
      get 'attendances/superior_info'
      patch 'attendances/superior_update'
      get 'status_info'
      get   'attendances/timetable_edit'
      patch 'attendances/timetable_edit_update'
      patch 'attendances/request_one_update'
      get 'attendances/notices_one'
      patch 'attendances/notices_one_update'
    end
    resources :attendances, only: :update do
      member do
        patch 'attendances/overtime_update'
      end 
    end 
  end
  resources :offices 
end