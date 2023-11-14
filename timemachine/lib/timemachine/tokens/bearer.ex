defmodule Timemachine.Tokens.Bearer do
  use Joken.Config

  @doc false
  def token_config, do: default_claims(default_exp: 60 * 60 * 24 * 30) # 30 days

  @doc """
  Extracts the `id` of the current user from the bearer token.

  ## Parameters

  - `conn` (type: Plug.Conn.t()): The Plug connection.

  ## Returns

  Returns the `id` of the current user or `nil` if extraction fails.

  """
  @spec get_current_user_id(Plug.Conn.t()) :: integer() | nil
  def get_current_user_id(conn) do
    {:ok, bearer} = get_from_conn(conn)
    {:ok, claims} = verify(bearer)
    user = Map.get(claims, "user")
    user["id"]
  end

  @doc """
  Retrieves the bearer token from a connection by reading the `authorization` header.

  ## Parameters

  - `conn` (type: Plug.Conn.t()): The Plug connection.

  ## Returns

  Returns a tuple `{:ok, token}` if the token is found, or `{:error, reason}` if not found.

  """
  @spec get_from_conn(Plug.Conn.t()) :: {:ok, String.t()} | {:error, String.t()}
  def get_from_conn(conn) do
    case Plug.Conn.get_req_header(conn, "authorization") do
      [bearer] -> {:ok, String.replace(bearer, "Bearer ", "")}
      _ -> {:error, "Bearer token not found"}
    end
  end
end
