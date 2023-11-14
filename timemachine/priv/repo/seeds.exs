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
Timemachine.Data.user_create(%{
  "username" => "macron",
  "email" => "macron@macron-demission.org",
  "password" => "explosion",
  "role" => "admin"
})
Timemachine.Data.user_create(%{
  "username" => "flamby",
  "email" => "flamby@macron-demission.org",
  "password" => "1234",
  "role" => "manager"
})
Timemachine.Data.user_create(%{
  "username" => "nicolas",
  "email" => "nicolas@macron-demission.org",
  "password" => "nicolas"
})
Timemachine.Data.team_create(%{
  "name" => "Gouvernement",
})
Timemachine.Data.team_create(%{
  "name" => "Rasta",
})
Timemachine.Data.userteam_create(1,1)
Timemachine.Data.userteam_create(2,1)
Timemachine.Data.userteam_create(3,2)
