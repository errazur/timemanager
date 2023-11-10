defmodule Timemachine.Repo.Migrations.CreateUsersTeams do
  use Ecto.Migration

  def change do
    create table(:users_teams) do
      add :user_id, references(:users)
      add :team_id, references(:teams)

      timestamps(type: :utc_datetime)
    end
    create unique_index(:users_teams, [:user_id, :team_id])
  end
end
