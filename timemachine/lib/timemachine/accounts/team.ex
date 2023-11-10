defmodule Timemachine.Accounts.Team do
  use Ecto.Schema
  import Ecto.Changeset

  schema "teams" do
    field :name, :string

    many_to_many :users, Timemachine.Accounts.User,
      join_through: Timemachine.Accounts.UserTeam

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
    |> cast_assoc(:users)
  end
end
