defmodule Timemachine.Data.UserTeam do
  use Ecto.Schema
  import Ecto.Changeset

  @doc """
  Defines the schema for the 'users_teams' table, representing the relationship between users and teams in the Timemachine application.

  ## Fields

  - `:user` (type: association): Belongs to a user.
  - `:team` (type: association): Belongs to a team.
  - `timestamps` (type: :utc_datetime): Automatic timestamps for record creation and updates.

  """
  schema "users_teams" do
    belongs_to :user, Timemachine.Data.User
    belongs_to :team, Timemachine.Data.Team

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, [:user_id, :team_id])
    |> validate_required([:user_id, :team_id])
    |> unique_constraint([:user_id, :team_id])
    |> cast_assoc(:user)
    |> cast_assoc(:team)
  end
end
