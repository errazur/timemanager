defmodule Timemachine.Data.Team do
  use Ecto.Schema
  import Ecto.Changeset

  @doc """
  Defines the schema for the 'teams' table, representing teams in the Timemachine application.

  ## Fields

  - `:name` (type: string): Unique name for the team.
  - `:users` (type: association): Many-to-many association with users through the `UserTeam` join table.
  - `timestamps` (type: :utc_datetime): Automatic timestamps for record creation and updates.

  """
  schema "teams" do
    # UNIQUE
    field :name, :string

    many_to_many :users, Timemachine.Data.User,
      join_through: Timemachine.Data.UserTeam

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
