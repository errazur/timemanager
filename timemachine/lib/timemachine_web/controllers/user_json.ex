defmodule TimemachineWeb.UserJSON do
  @moduledoc false

  alias Timemachine.Data.User
  alias Timemachine.Tokens.Bearer

  def search(%{users: users}) do
    %{data: for(user <- users, do: data(user))}
  end

  def show(%{user: user}) do
    %{data: data(user)}
  end

  def jwt(%{user: user, csrf: csrf}) do
    extra_claims = %{"user" => data(user)}
    {:ok, token, _claims} = Bearer.generate_and_sign(extra_claims)
    {:ok, _claim_map} = Bearer.verify_and_validate(token)
    %{bearer: token, _csrf_token: csrf}
  end

  def data(%User{} = user) do
    %{
      id: user.id,
      username: user.username,
      email: user.email,
      role: user.role,
      teams: for(team <- user.teams, do: TimemachineWeb.TeamJSON.data_no_users(team))
    }
  end

  # prevents infinite loop
  def data_no_teams(%User{} = user) do
    %{
      id: user.id,
      username: user.username,
      email: user.email,
      role: user.role,
    }
  end
end
