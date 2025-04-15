require 'rails_helper'

RSpec.describe "SleepRecords API", type: :request do
  let!(:user) { User.create!(name: "TestUser") }

  describe "POST /users/:id/clock-in" do
    it "creates a clock-in record" do
      post "/users/#{user.id}/clock-in" , as: :json

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json["user_id"]).to eq(user.id)
      expect(json["clock_in_at"]).not_to be_nil
      expect(json["clock_out_at"]).to be_nil
    end
  end

  describe "POST /users/:id/clock-in (edge cases)" do
    it "prevents multiple open clock-ins" do
      user.sleep_records.create!(clock_in_at: Time.now)
  
      post "/users/#{user.id}/clock-in" , as: :json
  
      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expect(json["error"]).to match(/Already clocked in. Please clock out first./i)
    end
  end

  describe "POST /users/:id/clock-out" do
    it "updates the last open sleep record with clock_out_at" do
      sleep_record = user.sleep_records.create!(clock_in_at: Time.now)

      post "/users/#{user.id}/clock-out" , as: :json

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["clock_out_at"]).not_to be_nil
      expect(json["id"]).to eq(sleep_record.id)
    end
  end

  describe "POST /users/:id/clock-out (edge cases)" do
    it "returns error if no open clock-in exists" do
      post "/users/#{user.id}/clock-out", as: :json
  
      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expect(json["error"]).to match(/User already has an active sleep session/i)
    end
  end

  describe "GET /users/:id/sleep-records" do
    it "returns the user's sleep records" do
      user.sleep_records.create!(clock_in_at: 10.hours.ago, clock_out_at: 2.hours.ago)
      user.sleep_records.create!(clock_in_at: 1.day.ago, clock_out_at: 20.hours.ago)

      get "/users/#{user.id}/sleep-records"

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json.length).to eq(2)
      expect(json.first["user_id"]).to eq(user.id)
    end
  end
end
