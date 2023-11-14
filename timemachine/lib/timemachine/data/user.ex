defmodule Timemachine.Data.User do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :username, :email]}

  @roles ["employee", "manager", "admin"]

  @default_role "employee"

  def default_role, do: @default_role

  @doc """
  Defines the schema for the 'users' table, representing users in the Timemachine application.

  ## Fields

  - `:username` (type: string): Unique username for the user.
  - `:email` (type: string): Unique email address for the user.
  - `:password_hash` (type: binary): Hashed password for the user.
  - `:role` (type: string, default: #{@default_role}): Role of the user (one of #{@roles}).
  - `:teams` (type: association): Many-to-many association with teams through the `UserTeam` join table.
  - `timestamps` (type: :utc_datetime): Automatic timestamps for record creation and updates.

  ## Default Role

  When creating a user, the `:role` field uses the default value if no role is specified or the specified role does not exist.

  """
  schema "users" do
    # UNIQUE
    field :username, :string

    # UNIQUE
    field :email, :string

    # Nota Bene : inserted value should have key "password", the model will replace it with the hashed value
    field :password_hash, :binary

    # Nota Bene : if inserted value is not included in @roles, @default_role will be set instead
    field :role, :string, default: @default_role

    many_to_many :teams, Timemachine.Data.Team,
      join_through: Timemachine.Data.UserTeam

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(clean(attrs), [:username, :email, :password_hash, :role])
    |> validate_required([:username, :email, :password_hash, :role])
    |> validate_format(:email, ~r/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, message: "Le format de l'email est invalide")
    |> unique_constraint(:username)
    |> unique_constraint(:email)
    |> cast_assoc(:teams)
  end

  @doc false
  def clean(attrs) do
    attrs
    |> replace_password_by_hash()
    |> verify_role()
  end

  @doc false
  defp replace_password_by_hash(attrs) do
    password = Map.get(attrs, "password")

    if password == nil do
      attrs
    else
      attrs
      |> Map.delete("password")
      |> Map.put("password_hash", :crypto.hash(:sha256, password))
    end
  end

  @doc false
  defp verify_role(attrs) do
    role = Map.get(attrs, "role")

    if role == nil or Enum.member?(@roles, role) do
      attrs
    else
      attrs
      |> Map.put("role", @default_role)
    end
  end

  defimpl Jason.Encoder do
    @doc false
    def encode(user, _opts) do
      %{
        "id" => user.id,
        "username" => user.username,
        "email" => user.email
        # Ajoutez d'autres champs ici si nécessaire
      }
    end
  end
end
