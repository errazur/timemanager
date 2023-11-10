defmodule Timemachine.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string, null: false, required: true
      add :email, :string, null: false, required: true

      timestamps(type: :utc_datetime)
    end
    create unique_index(:users, [:username])
    create unique_index(:users, [:email])
  end
end
