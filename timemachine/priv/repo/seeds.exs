# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Timemachine.Repo.insert!(%Timemachine.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

# Create users
Timemachine.Data.user_create(%{
  "username" => "adminUser",
  "email" => "admin@example.com",
  "password" => "adminPassword",
  "role" => "admin"
})
Timemachine.Data.user_create(%{
  "username" => "managerUser",
  "email" => "manager@example.com",
  "password" => "managerPassword",
  "role" => "manager"
})
Timemachine.Data.user_create(%{
  "username" => "regularUser",
  "email" => "user@example.com",
  "password" => "regularPassword"
})

# Create teams
Timemachine.Data.team_create(%{
  "name" => "TeamAlpha",
})
Timemachine.Data.team_create(%{
  "name" => "TeamBeta",
})

# Create user teams
Timemachine.Data.userteam_create(1,1)
Timemachine.Data.userteam_create(2,2)
Timemachine.Data.userteam_create(3,2)

# Create workingtimes
# User 1
Timemachine.Data.workingtime_create(%{ # 1
  "start" => "2023-11-13T08:28:32.000Z",
  "end" => "2023-11-13T10:59:16.000Z",
}, 1)
Timemachine.Data.workingtime_create(%{
  "start" => "2023-11-13T12:32:54.000Z",
  "end" => "2023-11-13T16:35:36.000Z",
}, 1)
Timemachine.Data.workingtime_create(%{ # 2
  "start" => "2023-11-14T08:31:02.000Z",
  "end" => "2023-11-14T10:57:49.000Z",
}, 1)

# User 2
Timemachine.Data.workingtime_create(%{ # 1
  "start" => "2023-11-13T08:28:32.000Z",
  "end" => "2023-11-13T10:59:16.000Z",
}, 2)
Timemachine.Data.workingtime_create(%{
  "start" => "2023-11-13T12:32:54.000Z",
  "end" => "2023-11-13T16:35:36.000Z",
}, 2)
Timemachine.Data.workingtime_create(%{ # 2
  "start" => "2023-11-14T08:31:02.000Z",
  "end" => "2023-11-14T10:57:49.000Z",
}, 2)

# User 3
Timemachine.Data.workingtime_create(%{ # 1
  "start" => "2023-11-13T08:28:32.000Z",
  "end" => "2023-11-13T10:59:16.000Z",
}, 3)
Timemachine.Data.workingtime_create(%{
  "start" => "2023-11-13T12:32:54.000Z",
  "end" => "2023-11-13T16:35:36.000Z",
}, 3)
Timemachine.Data.workingtime_create(%{ # 2
  "start" => "2023-11-14T08:31:02.000Z",
  "end" => "2023-11-14T10:57:49.000Z",
}, 3)

# Create clock
# User 1
Timemachine.Data.clock_create(%{
  "status" => true,
  "time" => "2023-11-14T12:21:09.000Z",
}, 1)

# User 2
Timemachine.Data.clock_create(%{
  "status" => true,
  "time" => "2023-11-14T12:21:09.000Z",
}, 2)

# User 3
Timemachine.Data.clock_create(%{
  "status" => true,
  "time" => "2023-11-14T12:21:09.000Z",
}, 3)
