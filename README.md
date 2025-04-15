# README

## Prerequisite:
- ruby 3.4.2
- rails 8.0.2
- mysql

## How to run 
- install the dependencies with `bundle install`
- make sure `config/database.yml` is modified to connect your local mysql 
- run `rails db:create` , `rails db:migrate` , `rails db:seed` to create, migrate and seed the db respectively
- run `rails s` to start your app up. it is accessible from `localhost:3000`
- call the api (see below: API Request for example)  
- you could run the test cases with `bundle exec rspec`

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
* assuming previous week is 1 week ago from request time

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


## API Request
### User Clock In
- [POST] /users/{id}/clock-in
- Request Body: {}
- Response: 
```
{
    "id": 4,
    "user_id": 1,
    "clock_in_at": "2025-04-14T17:03:04.715Z",
    "clock_out_at": null,
    "created_at": "2025-04-14T17:03:04.000Z"
}
```

### User Clock Out
- [POST] /users/{id}/clock-out
- Request Body: {}
- Response: 
```
{
    "user_id": 1,
    "clock_out_at": "2025-04-14T17:03:30.844Z",
    "id": 4,
    "clock_in_at": "2025-04-14T17:03:04.715Z",
    "created_at": "2025-04-14T17:03:04.000Z"
}
```

### Get User Sleep Records
- [GET] /users/{id}/sleep-records
- Request Body: {}
- Response:
```
[
    {
        "id": 2,
        "user_id": 1,
        "clock_in_at": "2025-04-14T16:52:29.990Z",
        "clock_out_at": "2025-04-14T16:52:32.153Z",
        "created_at": "2025-04-14T16:52:29.000Z"
    },
    {
        "id": 1,
        "user_id": 1,
        "clock_in_at": "2025-04-14T16:39:31.402Z",
        "clock_out_at": "2025-04-14T16:51:54.014Z",
        "created_at": "2025-04-14T16:39:31.000Z"
    }
]
```
### Follow User
- [POST] /users/{id}/follow
- Request Body:
```
{
  "followed_id": 1
}
```
- Response:
```
{
    "message": "Now following user 1"
}
```

### Unfollow User
- [POST] /users/{id}/unfollow
- Request Body:
```
{
  "followed_id": 2
}
```
- Response:
```
{
    "message": "Unfollowed user 2"
}
```
### Get Following Sleep Records
- [GET] /users/{id}/followings/sleep-records
- Request Body: {}
- Response:
```
[
    {
        "id": 1,
        "user_id": 1,
        "clock_in_at": "2025-04-14T16:39:31.402Z",
        "clock_out_at": "2025-04-14T16:51:54.014Z",
        "created_at": "2025-04-14T16:39:31.000Z",
        "duration_seconds": 742
    },
    {
        "id": 4,
        "user_id": 1,
        "clock_in_at": "2025-04-14T17:03:04.715Z",
        "clock_out_at": "2025-04-14T17:03:30.844Z",
        "created_at": "2025-04-14T17:03:04.000Z",
        "duration_seconds": 26
    }
]
```