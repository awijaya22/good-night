# app/controllers/followings_controller.rb
class FollowingsController < ApplicationController
    before_action :set_user
  
    def sleep_records
        # TODO: could be improved by using a query to get the sleep records of the followings
        one_week_ago = 1.week.ago

        records = SleepRecord
            .joins(:user)
            .where(user_id: @user.following_ids)
            .where.not(clock_out_at: nil)
            .where("clock_in_at >= ?", one_week_ago)
            .select(
            'sleep_records.*, (TIMESTAMPDIFF(SECOND, clock_in_at, clock_out_at)) AS duration_seconds'
            )
            .order('duration_seconds DESC')

        render json: records.as_json(methods: [:duration_seconds])
    end
  
    private
  
    def set_user
      @user = User.find(params[:user_id])
    end
  end
  