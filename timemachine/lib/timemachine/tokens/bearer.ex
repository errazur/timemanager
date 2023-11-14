defmodule Timemachine.Tokens.Bearer do
  use Joken.Config

  @doc false
  def token_config, do: default_claims(default_exp: 60 * 60 * 24 * 30) # 30 days

  @doc """
  Returns the `id` of the current `user`. It is extracted from the bearer.
  """
  @spec get_current_user_id(Plug.Conn.t()) :: integer() | nil
  def get_current_user_id(conn) do
    {:ok, bearer} = get_from_conn(conn)
    {:ok, claims} = verify(bearer)
    user = Map.get(claims, "user")
    user["id"]
  end

  @doc """
  Returns the bearer token from a `conn` by reading `authorization` header.
  """
  @spec get_from_conn(Plug.Conn.t()) :: {:ok, String.t()} | {:error, String.t()}
  def get_from_conn(conn) do
    case Plug.Conn.get_req_header(conn, "authorization") do
      [bearer] -> {:ok, String.replace(bearer, "Bearer ", "")}
      _ -> {:error, "Bearer token not found"}
    end
  end
end
