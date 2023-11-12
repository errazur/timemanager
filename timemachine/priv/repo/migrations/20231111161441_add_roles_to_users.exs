defmodule Timemachine.Repo.Migrations.AddRolesToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :role, :string, null: false, required: true
    end
  end
end
