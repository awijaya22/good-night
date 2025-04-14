class CreateSleepRecords < ActiveRecord::Migration[7.1]
    def change
      create_table :sleep_records do |t|
        t.references :user, null: false, foreign_key: true
        t.datetime :clock_in_at, null: false
        t.datetime :clock_out_at
        t.timestamp :created_at, null:false, default: -> { "CURRENT_TIMESTAMP" }
      end
  
      add_index :sleep_records, [:user_id, :clock_in_at]
    end
  end