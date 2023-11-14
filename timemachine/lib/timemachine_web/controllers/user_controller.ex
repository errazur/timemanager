defmodule TimemachineWeb.UserController do
  use TimemachineWeb, :controller

  alias Timemachine.Tokens.Bearer
  alias Timemachine.Tokens.CSRF
  alias Timemachine.Data
  alias Timemachine.Data.User

  action_fallback TimemachineWeb.FallbackController

  @moduledoc """
  Controller for managing user data.

  ## Actions

  - `search(conn, params)`: Search for users based on specified parameters.
  - `login(conn, %{"credentials" => credentials})`: Login using username and password, sends JWT and CSRF tokens.
  - `tokens(conn, _params)`: Send JWT and CSRF tokens for the current user.
  - `create(conn, %{"user" => user_params})`: Create a new user.
  - `show(conn, %{"id" => id})`: Retrieve details of a specific user.
  - `update(conn, %{"id" => id, "user" => user_params})`: Update details of a specific user.
  - `update_password(conn, %{"id" => id, "password" => password, "new_password" => new_password})`: Update user password.
  - `delete(conn, %{"id" => id})`: Delete a specific user.

  ## Helper Functions

  - `send_tokens(conn, user)`: Send JWT and CSRF tokens in the response headers.

  """

  @doc """
  Search for users based on specified parameters.

  ## Parameters

  - `conn` (type: Plug.Conn.t()): The connection struct.
  - `params` (type: map()): Map containing search parameters.

  ## Returns

  Renders the `:search` view with a list of users based on search parameters.

  """
  def search(conn, params) do
    users = Data.user_search(params)
    render(conn, :search, users: users)
  end

  @doc """
  Login using username and password, sends JWT and CSRF tokens.

  ## Parameters

  - `conn` (type: Plug.Conn.t()): The connection struct.
  - `params` (type: map()): Map containing parameters, including `"credentials"`.

  ## Returns

  Sends JWT and CSRF tokens in the response headers.

  """
  def login(conn, %{"credentials" => credentials}) do
    with {:ok, %User{} = user} <- Data.user_try_login(credentials) do
      CSRF.generate(user.id)
      send_tokens(conn, user)
    end
  end

  @doc """
  Send JWT and CSRF tokens for the current user.

  ## Parameters

  - `conn` (type: Plug.Conn.t()): The connection struct.
  - `params` (type: map()): Map containing parameters (not used).

  ## Returns

  Sends JWT and CSRF tokens in the response headers.

  """
  def tokens(conn, _params) do
    send_tokens(conn, Data.user_get(Bearer.get_current_user_id(conn)))
  end

  @doc """
  Create a new user.

  ## Parameters

  - `conn` (type: Plug.Conn.t()): The connection struct.
  - `params` (type: map()): Map containing parameters, including `"user"`.

  ## Returns

  Renders the `:show` view with the details of the created user.

  """
  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Data.user_create(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/users/#{user}")
      |> render(:show, user: user)
    end
  end

  @doc """
  Retrieve details of a specific user.

  ## Parameters

  - `conn` (type: Plug.Conn.t()): The connection struct.
  - `params` (type: map()): Map containing parameters, including `"id"`.

  ## Returns

  Renders the `:show` view with details of the specified user.

  """
  def show(conn, %{"id" => id}) do
    user = Data.user_get(id)
    render(conn, :show, user: user)
  end

  @doc """
  Update details of a specific user.

  ## Parameters

  - `conn` (type: Plug.Conn.t()): The connection struct.
  - `params` (type: map()): Map containing parameters, including `"id"` and `"user"`.

  ## Returns

  Renders the `:show` view with the updated details of the user.

  """
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

  @doc """
  Update user password.

  ## Parameters

  - `conn` (type: Plug.Conn.t()): The connection struct.
  - `params` (type: map()): Map containing parameters, including `"id"`, `"password"`, and `"new_password"`.

  ## Returns

  Sends JWT and CSRF tokens in the response headers.

  """
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

  @doc """
  Delete a specific user.

  ## Parameters

  - `conn` (type: Plug.Conn.t()): The connection struct.
  - `params` (type: map()): Map containing parameters, including `"id"`.

  ## Returns

  Responds with a `:no_content` status.

  """
  def delete(conn, %{"id" => id}) do
    user = Data.user_get(id)

    with {:ok, %User{}} <- Data.user_delete(user) do
      send_resp(conn, :no_content, "")
    end
  end

  @doc false
  defp send_tokens(conn, user) do
    conn
    |> put_resp_header("x-csrf-token", CSRF.get(user.id))
    |> render(:jwt, [user: user, csrf: CSRF.get(user.id)])
  end
end
