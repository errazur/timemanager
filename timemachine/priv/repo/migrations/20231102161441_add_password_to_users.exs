defmodule Timemachine.Repo.Migrations.AddPasswordToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :password_hash, :binary
    end
  end
end
