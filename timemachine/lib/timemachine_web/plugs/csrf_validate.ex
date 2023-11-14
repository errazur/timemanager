defmodule TimemachineWeb.Plugs.CSRFValidate do
  alias Timemachine.Tokens.Bearer
  alias Timemachine.Tokens.CSRF
  alias TimemachineWeb.FallbackController

  @moduledoc """
  Plug for CSRF token validation.

  ## Description

  This plug is responsible for validating CSRF tokens for POST, PUT, and DELETE requests. It checks the presence of a CSRF token in the request and verifies its validity. If the token is invalid or missing, it falls back to the `FallbackController` with a 401 Unauthorized error. If the token is present but not authorized for the current user, it falls back with a 403 Forbidden error.

  ## Usage

  Add this plug to your pipeline in the router or controller to enforce CSRF token validation.

  ```elixir
  pipeline :api do
    plug TimemachineWeb.Plugs.CSRFValidate
    # ... other plugs and middleware
  end
  ```
  """

  @behaviour Plug
  def init(default), do: default

  @doc """
  Call function for the CSRFValidate plug.

  ## Parameters

  - `conn` (type: Plug.Conn.t()): The connection struct.
  - `_default` (type: term()): The default value.

  ## Returns

  If the CSRF token is valid, the connection is returned. If the token is invalid or missing, it falls back to the `FallbackController` with a 401 Unauthorized error. If the token is present but not authorized for the current user, it falls back with a 403 Forbidden error.
  """
  def call(conn, _default), do: authenticate(conn)

  defp authenticate(conn) do
    if conn.method == "POST" or conn.method == "PUT" or conn.method == "DELETE" do
      case CSRF.get_from_conn(conn) do
        {:error, _reason} ->
          FallbackController.call(conn, {:error, 401})

        {:ok, csrf} ->
          user_id = Bearer.get_current_user_id(conn)
          if CSRF.authorized?(user_id, csrf) do
            conn
          else
            FallbackController.call(conn, {:error, 403})
          end
      end
    else
      conn
    end
  end
end
