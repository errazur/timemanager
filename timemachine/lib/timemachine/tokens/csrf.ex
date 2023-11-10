defmodule Timemachine.Tokens.CSRF do
  use Agent

  def start_link(_arg) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def generate(user_id) do
    Agent.update(__MODULE__, &Map.put(&1, user_id,  Base.encode64(:crypto.strong_rand_bytes(24))))
  end

  def get(user_id) do
    Agent.get(__MODULE__, &Map.get(&1, user_id))
  end

  def delete(user_id) do
    Agent.update(__MODULE__, &Map.delete(&1, user_id))
  end

  def authorized?(user_id, csrf) do
    stored = get(user_id)
    stored == csrf
  end

  def get_from_conn(conn) do
    case Plug.Conn.get_req_header(conn, "x-csrf-token") do
      [csrf] -> {:ok, csrf}
      _ -> {:error, "csrf token not found"}
    end
  end
end
