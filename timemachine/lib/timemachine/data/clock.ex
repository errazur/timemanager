defmodule Timemachine.Data.Clock do
  use Ecto.Schema
  import Ecto.Changeset

  @doc """
  Defines the schema for the 'clocks' table, representing clock entries in the Timemachine application.

  ## Fields

  - `:status` (type: boolean, default: false): The status of the clock entry.
  - `:time` (type: :utc_datetime): The timestamp of the clock entry.
  - `:user` (type: association): Belongs to a user through the `user_id` foreign key.
  - `timestamps` (type: :utc_datetime): Automatic timestamps for record creation and updates.

  """
  schema "clocks" do
    field :status, :boolean, default: false
    field :time, :utc_datetime
    belongs_to :user, Timemachine.Data.User, foreign_key: :user_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(clock, attrs) do
    clock
    |> cast(attrs, [:status, :time, :user_id])
    |> validate_required([:status, :time, :user_id])
    |> cast_assoc(:user)
  end
end
