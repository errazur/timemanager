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
Timemachine.Data.create_user(%{
  "username" => "adminUser",
  "email" => "admin@example.com",
  "password" => "adminPassword",
  "role" => "admin"
})
Timemachine.Data.create_user(%{
  "username" => "managerUser",
  "email" => "manager@example.com",
  "password" => "managerPassword",
  "role" => "manager"
})
Timemachine.Data.create_user(%{
  "username" => "regularUser",
  "email" => "user@example.com",
  "password" => "regularPassword"
})

# Create teams
Timemachine.Data.create_team(%{
  "name" => "TeamAlpha",
})
Timemachine.Data.create_team(%{
  "name" => "TeamBeta",
})

# Create user teams
Timemachine.Data.create_user_team(1,1)
Timemachine.Data.create_user_team(2,2)
Timemachine.Data.create_user_team(3,2)

# Create workingtimes
# User 1
Timemachine.Data.create_workingtime(%{ # 1
  "start" => "2023-11-13T08:28:32.000Z",
  "end" => "2023-11-13T10:59:16.000Z",
}, 1)
Timemachine.Data.create_workingtime(%{
  "start" => "2023-11-13T12:32:54.000Z",
  "end" => "2023-11-13T16:35:36.000Z",
}, 1)
Timemachine.Data.create_workingtime(%{ # 2
  "start" => "2023-11-14T08:31:02.000Z",
  "end" => "2023-11-14T10:57:49.000Z",
}, 1)

# User 2
Timemachine.Data.create_workingtime(%{ # 1
  "start" => "2023-11-13T08:28:32.000Z",
  "end" => "2023-11-13T10:59:16.000Z",
}, 2)
Timemachine.Data.create_workingtime(%{
  "start" => "2023-11-13T12:32:54.000Z",
  "end" => "2023-11-13T16:35:36.000Z",
}, 2)
Timemachine.Data.create_workingtime(%{ # 2
  "start" => "2023-11-14T08:31:02.000Z",
  "end" => "2023-11-14T10:57:49.000Z",
}, 2)

# User 3
Timemachine.Data.create_workingtime(%{ # 1
  "start" => "2023-11-13T08:28:32.000Z",
  "end" => "2023-11-13T10:59:16.000Z",
}, 3)
Timemachine.Data.create_workingtime(%{
  "start" => "2023-11-13T12:32:54.000Z",
  "end" => "2023-11-13T16:35:36.000Z",
}, 3)
Timemachine.Data.create_workingtime(%{ # 2
  "start" => "2023-11-14T08:31:02.000Z",
  "end" => "2023-11-14T10:57:49.000Z",
}, 3)

# Create clock
# User 1
Timemachine.Data.create_clock(%{
  "status" => true,
  "time" => "2023-11-14T12:21:09.000Z",
}, 1)

# User 2
Timemachine.Data.create_clock(%{
  "status" => true,
  "time" => "2023-11-14T12:21:09.000Z",
}, 2)

# User 3
Timemachine.Data.create_clock(%{
  "status" => true,
  "time" => "2023-11-14T12:21:09.000Z",
}, 3)
