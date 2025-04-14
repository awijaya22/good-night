class CreateFollows < ActiveRecord::Migration[7.1]
    def change
      create_table :follows do |t|
        t.references :follower, null: false, foreign_key: { to_table: :users }
        t.references :followed, null: false, foreign_key: { to_table: :users }
        t.timestamp :created_at, null:false, default: -> { "CURRENT_TIMESTAMP" }
        t.timestamp:deleted_at
      end
  
      add_index :follows, [:follower_id, :followed_id]
    end
  end