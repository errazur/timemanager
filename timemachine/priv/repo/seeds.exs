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
Timemachine.Accounts.create_user(%{
  "username" => "macron",
  "email" => "macron@macron-demission.org",
  "password" => "explosion"
})
Timemachine.Accounts.create_user(%{
  "username" => "flamby",
  "email" => "flamby@macron-demission.org",
  "password" => "1234"
})
Timemachine.Accounts.create_user(%{
  "username" => "nicolas",
  "email" => "nicolas@macron-demission.org",
  "password" => "nicolas"
})
Timemachine.Accounts.create_team(%{
  "name" => "Gouvernement",
})
Timemachine.Accounts.create_team(%{
  "name" => "Rasta",
})
Timemachine.Accounts.create_user_team(1,1)
Timemachine.Accounts.create_user_team(2,1)
Timemachine.Accounts.create_user_team(3,2)
