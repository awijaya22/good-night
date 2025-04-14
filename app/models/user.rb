class User < ApplicationRecord
    has_many :sleep_records, dependent: :destroy
  
    # Follow associations
    has_many :follows, foreign_key: :follower_id, dependent: :destroy
    has_many :followings, through: :follows, source: :followed
  
    has_many :reverse_follows, class_name: 'Follow', foreign_key: :followed_id, dependent: :destroy
    has_many :followers, through: :reverse_follows, source: :follower
  end