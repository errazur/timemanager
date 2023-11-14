defmodule TimemachineWeb.UserController do
  use TimemachineWeb, :controller

  alias Timemachine.Tokens.Bearer
  alias Timemachine.Tokens.CSRF
  alias Timemachine.Data
  alias Timemachine.Data.User

  action_fallback TimemachineWeb.FallbackController

  def search(conn, params) do
    users = Data.user_search(params)
    render(conn, :search, users: users)
  end

  # send jwt and csrf, login by username + password
  def login(conn, %{"credentials" => credentials}) do
    with {:ok, %User{} = user} <- Data.user_try_login(credentials) do
      CSRF.generate(user.id)
      send_tokens(conn, user)
    end
  end

  # send jwt and csrf, login by bearer
  def tokens(conn, _params) do
    send_tokens(conn, Data.user_get(Bearer.get_current_user_id(conn)))
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Data.user_create(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/users/#{user}")
      |> render(:show, user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Data.user_get(id)
    render(conn, :show, user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Data.user_get(id)

    # Never update password with this route
    user_params = Map.delete(user_params, "password")

    with {:ok, %User{} = user} <- Data.user_update(user, user_params) do
      if user.id == Bearer.get_current_user_id(conn) do
        send_tokens(conn, user)
      else
        render(conn, :show, user: user)
      end
    end
  end

  def update_password(conn, %{"id" => id, "password" => password, "new_password" => new_password}) do
    # Verify old password matches
    with {:ok, %User{} = user} <- Data.user_try_login(id, password) do
      # Make sure the request is from the target user
      if user.id != Bearer.get_current_user_id(conn) do
        {:error, 403}
      else
        with {:ok, %User{} = user} <- Data.user_update(user, %{"password" => new_password}) do
          send_tokens(conn, user)
        end
      end
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Data.user_get(id)

    with {:ok, %User{}} <- Data.user_delete(user) do
      send_resp(conn, :no_content, "")
    end
  end

  defp send_tokens(conn, user) do
    conn
    |> put_resp_header("x-csrf-token", CSRF.get(user.id))
    |> render(:jwt, [user: user, csrf: CSRF.get(user.id)])
  end
end
