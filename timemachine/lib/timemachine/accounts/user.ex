defmodule Timemachine.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :username, :email]}

  schema "users" do
    field :username, :string
    field :email, :string
    field :password_hash, :binary

    many_to_many :teams, Timemachine.Accounts.Team,
      join_through: Timemachine.Accounts.UserTeam

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(clean(attrs), [:username, :email, :password_hash])
    |> validate_required([:username, :email, :password_hash])
    |> validate_format(:email, ~r/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, message: "Le format de l'email est invalide")
    |> unique_constraint(:username)
    |> unique_constraint(:email)
  end

  def clean(attrs) do
    attrs
    |> replace_password_by_hash()
  end

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

  defimpl Jason.Encoder do
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
