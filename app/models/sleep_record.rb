class SleepRecord < ApplicationRecord
    belongs_to :user
  
    def duration_seconds
        return nil unless clock_in_at && clock_out_at
        (clock_out_at - clock_in_at).to_i
    end
  end