Rails.application.routes.draw do
  resources :users, only: [] do
    post 'clock-in', to: 'sleep_records#clock_in'
    post 'clock-out', to: 'sleep_records#clock_out'
    get 'sleep-records', to: 'sleep_records#index'
    post 'follow', to: 'follows#create'
    post 'unfollow', to: 'follows#destroy'
    get 'followings/sleep-records', to: 'followings#sleep_records'
  end
end