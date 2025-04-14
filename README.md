# README

Build on:
- ruby 3.4.2
- rails 8.0.2

## Product Requirement
We require some restful APIS to achieve the following:
1. Clock In operation, and return all clocked-in times, ordered by
created time.
2. Users can follow and unfollow other users.
3. See the sleep records of a user's All following users' sleep
records. from the previous week, which are sorted based on the duration
of All friends sleep length.
This is 3rd requirement response example
```
{
  record 1 from user A,
  record 2 from user B,
  record 3 from user A,
  ...
}
```

## Assumption
* registration and login is done 
* user can't delete sleep_records, as the sleep_records should be insert only 

## Database Design 
### Table: users
* id: bigint (primary key)
* name: varchar
* created_at: datetime
* updated_at: datetime

### Table: sleep_records
* id: bigint (primary key)
* user_id: references users(id)
* clock_in_at: datetime
* clock_out_at: datetime
* created_at: datetime

index(user_id, clock_in_at)  // to support requirement 1

### Table: follows
* id: bigint (primary key)
* follower_id: references users(id)
* followed_id: references users(id)
* created_at: datetime
* deleted_at: datetime

index(follower_id, followed_id, deleted_at) // to support requirement 2 and 3


## [TODO] API Request
## [TODO] How to run 