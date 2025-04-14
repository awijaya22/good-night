class CreateUsers < ActiveRecord::Migration[7.1]
    def change
      create_table :users do |t|
        t.string :name, null: false
        t.timestamp :created_at, null:false, default: -> { 'CURRENT_TIMESTAMP' }
        t.timestamp :updated_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
        t.timestamp :deleted_at
      end
    end
  end