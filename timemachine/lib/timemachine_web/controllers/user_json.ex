defmodule TimemachineWeb.UserJSON do
  alias Timemachine.Accounts.User
  alias Timemachine.Token

  def search(%{users: users}) do
    %{data: for(user <- users, do: data(user))}
  end

  def show(%{user: user}) do
    %{data: data(user)}
  end

  def jwt(%{user: user, csrf: csrf}) do
    extra_claims = %{"user" => data(user)}
    {:ok, token, _claims} = Token.generate_and_sign(extra_claims)
    {:ok, _claim_map} = Token.verify_and_validate(token)
    %{bearer: token, _csrf_token: csrf}
  end

  def data(%User{} = user) do
    %{
      id: user.id,
      username: user.username,
      email: user.email
    }
  end
end
