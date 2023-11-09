defmodule Timemachine.Utils do
  alias Timemachine.Token

  def parse_boolean(boolean) do
    case boolean do
      "true" -> true
      "false" -> false
      _ -> nil
    end
  end

  def get_current_user_id(conn) do
    {:ok, bearer} = get_bearer_token(conn)
    {:ok, claims} = Token.verify(bearer)
    user = Map.get(claims, "user")
    user["id"]
  end

  def get_bearer_token(conn) do
    case Plug.Conn.get_req_header(conn, "authorization") do
      [bearer] -> {:ok, String.replace(bearer, "Bearer ", "")}
      _ -> {:error, "Bearer token not found"}
    end
  end
end
