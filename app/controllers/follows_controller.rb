# app/controllers/follows_controller.rb
class FollowsController < ApplicationController
    before_action :set_user
  
    def create
      followed = User.find_by(id: params[:followed_id])
      return render json: { error: "User to follow not found" }, status: :not_found unless followed
  
      if @user.followings.include?(followed)
        render json: { error: "Already following user #{followed.id}" }, status: :unprocessable_entity
      else
        @user.followings << followed
        render json: { message: "Now following user #{followed.id}" }, status: :created
      end
    end
  
    def destroy
      followed = User.find_by(id: params[:followed_id])
      return render json: { error: "User to unfollow not found" }, status: :not_found unless followed
  
      follow = @user.follows.find_by(followed_id: followed.id)
      if follow
        follow.destroy
        render json: { message: "Unfollowed user #{followed.id}" }, status: :ok
      else
        render json: { error: "You are not following user #{followed.id}" }, status: :unprocessable_entity
      end
    end
  
    private
  
    def set_user
      @user = User.find(params[:user_id])
    end
  end
  