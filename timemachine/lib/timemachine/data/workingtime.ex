defmodule Timemachine.Data.Workingtime do
  use Ecto.Schema
  import Ecto.Changeset

  @doc """
  Defines the schema for the 'workingtimes' table, representing working times in the Timemachine application.

  ## Fields

  - `:start` (type: :utc_datetime): Start time of the working time.
  - `:end` (type: :utc_datetime): End time of the working time.
  - `:user` (type: association): Belongs to a user through the `user_id` foreign key.
  - `timestamps` (type: :utc_datetime): Automatic timestamps for record creation and updates.

  """
  schema "workingtimes" do
    field :start, :utc_datetime
    field :end, :utc_datetime
    belongs_to :user, Timemachine.Data.User, foreign_key: :user_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(workingtime, attrs) do
    workingtime
    |> cast(attrs, [:start, :end, :user_id])
    |> validate_required([:start, :end, :user_id])
    |> cast_assoc(:user)
  end
end
