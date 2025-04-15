require 'rails_helper'

RSpec.describe "Follows API", type: :request do
  let!(:user) { User.create!(name: "Follower") }
  let!(:other_user) { User.create!(name: "Followed") }

  # follow
  describe "POST /users/:id/follow" do
    it "allows a user to follow another user" do
      post "/users/#{user.id}/follow", params: { followed_id: other_user.id } , as: :json

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json["message"]).to eq("Now following user #{other_user.id}")
    end
  end

  # follow edge cases
  describe "POST /users/:id/follow (edge cases)" do
    it "returns error when trying to follow self" do
      post "/users/#{user.id}/follow", params: { followed_id: user.id } , as: :json
  
      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expect(json["error"]).to match(/cannot follow yourself/i)
    end
  
    it "returns error when already following the user" do
      user.followings << other_user
  
      post "/users/#{user.id}/follow", params: { followed_id: other_user.id } , as: :json
  
      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expect(json["error"]).to match(/already following/i)
    end
  
    it "returns error when followed_id is missing" do
      post "/users/#{user.id}/follow", params: {} , as: :json
  
      expect(response).to have_http_status(:bad_request)
      json = JSON.parse(response.body)
      expect(json["error"]).to match(/followed_id is required/i)
    end
  end

  # unfollow
  describe "POST /users/:id/unfollow" do
    before do
      user.followings << other_user
    end

    it "allows a user to unfollow another user" do
      post "/users/#{user.id}/unfollow", params: { followed_id: other_user.id } , as: :json

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["message"]).to eq("Unfollowed user #{other_user.id}")
    end
  end

  # unfollow edge cases 
  describe "POST /users/:id/unfollow (edge cases)" do
    it "returns error when not following the user" do
      post "/users/#{user.id}/unfollow", params: { followed_id: other_user.id } , as: :json
  
      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expect(json["error"]).to match(/not following/i)
    end
  end

  # get following sleep records
  describe "GET /users/:id/followings/sleep-records" do
    let!(:followed) { User.create!(name: "FollowedUser") }

    before do
      user.followings << followed
      followed.sleep_records.create!(
        clock_in_at: 8.hours.ago,
        clock_out_at: 2.hours.ago
      )
    end

    it "returns sleep records of following users sorted by duration" do
      get "/users/#{user.id}/followings/sleep-records" , as: :json

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json.first["user_id"]).to eq(followed.id)
      expect(json.first["duration_seconds"]).to eq(6 * 3600)
    end
  end
end
