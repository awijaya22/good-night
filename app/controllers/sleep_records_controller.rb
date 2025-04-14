class SleepRecordsController < ApplicationController
    before_action :set_user
  
    def clock_in
      if @user.sleep_records.where(clock_out_at: nil).exists?
        return render json: { error: "Already clocked in. Please clock out first." }, status: :unprocessable_entity
      end
  
      record = @user.sleep_records.create!(clock_in_at: Time.current)
      render json: record, status: :created
    end
  
    def clock_out
      record = @user.sleep_records.where(clock_out_at: nil).order(created_at: :desc).first
  
      unless record
        return render json: { error: "No active sleep record found to clock out." }, status: :not_found
      end
  
      record.clock_out_at = Time.current
  
      if record.save
        render json: record, status: :ok
      else
        render json: { error: record.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    def index
      records = @user.sleep_records.order(created_at: :desc)
      render json: records
    end
  
    private
  
    def set_user
      @user = User.find(params[:user_id])
    end
  end
  