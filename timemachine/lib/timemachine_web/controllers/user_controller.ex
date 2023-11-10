defmodule TimemachineWeb.UserController do
  use TimemachineWeb, :controller

  alias Timemachine.Tokens.Bearer
  alias Timemachine.Tokens.CSRF
  alias Timemachine.Accounts
  alias Timemachine.Accounts.User

  action_fallback TimemachineWeb.FallbackController

  def search(conn, params) do
    users = Accounts.search_user(params)
    render(conn, :search, users: users)
  end

  # send jwt and csrf, login by username + password
  def login(conn, %{"credentials" => credentials}) do
    with {:ok, %User{} = user} <- Accounts.try_login(credentials) do
      CSRF.generate(user.id)
      send_tokens(conn, user)
    end
  end

  # send jwt and csrf, login by bearer
  def tokens(conn, _params) do
    send_tokens(conn, Accounts.get_user!(Bearer.get_current_user_id(conn)))
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/users/#{user}")
      |> render(:show, user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, :show, user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      if user.id == Bearer.get_current_user_id(conn) do
        send_tokens(conn, user)
      else
        render(conn, :show, user: user)
      end
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end

  defp send_tokens(conn, user) do
    conn
    |> put_resp_header("x-csrf-token", CSRF.get(user.id))
    |> render(:jwt, [user: user, csrf: CSRF.get(user.id)])
  end
end
