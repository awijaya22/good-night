# Clear old data
SleepRecord.delete_all
Follow.delete_all
User.delete_all

# Create Users
users = []
users << User.create!(name: 'Alice')
users << User.create!(name: 'Bob')
users << User.create!(name: 'Charlie')
users << User.create!(name: 'David')

# Follow relationships
users[0].followings << users[1] 
users[0].followings << users[2] 
users[0].followings << users[3]
users[1].followings << users[2]
users[1].followings << users[3]
users[2].followings << users[3]

# Create some sleep records
users.each do |user|
  3.times do |i|
    clock_in = (i + 1).days.ago.change(hour: 23)
    clock_out = clock_in + rand(6..9).hours

    user.sleep_records.create!(
      clock_in_at: clock_in,
      clock_out_at: clock_out,
    )
  end
end

puts "Seeded #{User.count} users, #{SleepRecord.count} sleep records, and #{Follow.count} follows."
