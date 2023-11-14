defmodule TimemachineWeb.Plugs.BearerValidate do
  alias Timemachine.Tokens.Bearer
  alias TimemachineWeb.FallbackController

  @moduledoc """
  Plug for Bearer token validation.

  ## Description

  This plug is responsible for authenticating requests using Bearer tokens. It checks the presence of a Bearer token in the request and verifies its validity. If the token is invalid or missing, it falls back to the `FallbackController` with a 401 Unauthorized error.

  ## Usage

  Add this plug to your pipeline in the router or controller to enforce Bearer token validation.

  ```elixir
  pipeline :api do
    plug TimemachineWeb.Plugs.BearerValidate
    # ... other plugs and middleware
  end
  ```
  """

  @behaviour Plug
  def init(default), do: default

  @doc """
  Call function for the BearerValidate plug.

  Parameters
  conn (type: Plug.Conn.t()): The connection struct.
  _default (type: term()): The default value.
  Returns
  If Bearer token is valid, the connection is returned. If the token is invalid or missing, it falls back to the FallbackController with a 401 Unauthorized error.

  """
  def call(conn, _default), do: authenticate(conn)

  defp authenticate(conn) do
    case Bearer.get_from_conn(conn) do
      {:error, _reason} ->
        FallbackController.call(conn, {:error, 401})

      {:ok, bearer} ->
        case Bearer.verify_and_validate(bearer) do
          {:error, _reason} ->
            FallbackController.call(conn, {:error, 401})

          {:ok, _claims} ->
            conn
        end
    end
  end

end
