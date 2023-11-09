defmodule TimemachineWeb.UserController do
  use TimemachineWeb, :controller

  alias Timemachine.Accounts
  alias Timemachine.Accounts.User
  alias Timemachine.Utils

  action_fallback TimemachineWeb.FallbackController

  def search(conn, params) do
    users = Accounts.search_user(params)
    render(conn, :search, users: users)
  end

  # send jwt and csrf, login by username + password
  def login(conn, %{"credentials" => credentials}) do
    with {:ok, %User{} = user} <- Accounts.try_login(credentials) do
      conn
      |> Plug.CSRFProtection.call(Plug.CSRFProtection.init([with: :clear_session]))
      |> send_tokens(user)
    end
  end

  # send jwt and csrf, login by bearer
  def tokens(conn, _params) do
    id = Utils.get_current_user_id(conn)
    user = Accounts.get_user!(id)
    send_tokens(conn, user)
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
      if user.id == Utils.get_current_user_id(conn) do
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
    |> put_resp_header("x-csrf-token", get_csrf_token())
    |> render(:jwt, [user: user, csrf: get_csrf_token()])
  end
end
