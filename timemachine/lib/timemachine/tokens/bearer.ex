defmodule Timemachine.Tokens.Bearer do
  use Joken.Config

  def token_config, do: default_claims(default_exp: 60 * 60 * 24 * 30) # 30 days

  def get_current_user_id(conn) do
    {:ok, bearer} = get_from_conn(conn)
    {:ok, claims} = verify(bearer)
    user = Map.get(claims, "user")
    user["id"]
  end

  def get_from_conn(conn) do
    case Plug.Conn.get_req_header(conn, "authorization") do
      [bearer] -> {:ok, String.replace(bearer, "Bearer ", "")}
      _ -> {:error, "Bearer token not found"}
    end
  end
end
