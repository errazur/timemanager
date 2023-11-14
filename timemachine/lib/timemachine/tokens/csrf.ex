defmodule Timemachine.Tokens.CSRF do
  @doc false
  use Agent

  @doc false
  def start_link(_arg) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  @doc """
  Generates a new CSRF token for the given `user_id`. Use `get(user_id)` to get the token.

  ## Parameters

  - `user_id` (type: integer()): The user ID for whom the CSRF token is generated.

  ## Returns

  Returns `:ok` if the token is generated successfully.

  """
  @spec generate(integer()) :: :ok
  def generate(user_id) do
    Agent.update(__MODULE__, &Map.put(&1, user_id,  Base.encode64(:crypto.strong_rand_bytes(24))))
  end

  @doc """
  Returns the CSRF token stored for the given `user_id`.

  ## Parameters

  - `user_id` (type: integer()): The user ID for whom the CSRF token is retrieved.

  ## Returns

  Returns the CSRF token as a string.

  """
  @spec get(integer()) :: String.t()
  def get(user_id) do
    Agent.get(__MODULE__, &Map.get(&1, user_id))
  end

   @doc """
  Deletes the CSRF token stored for the given `user_id`.

  ## Parameters

  - `user_id` (type: integer()): The user ID for whom the CSRF token is deleted.

  ## Returns

  Returns `:ok` if the token is deleted successfully.

  """
  @spec delete(integer()) :: :ok
  def delete(user_id) do
    Agent.update(__MODULE__, &Map.delete(&1, user_id))
  end

  @doc """
  Checks if the given CSRF token matches the stored one for this `user_id`.

  ## Parameters

  - `user_id` (type: integer()): The user ID for whom the CSRF token is checked.
  - `csrf` (type: String.t()): The CSRF token to be checked.

  ## Returns

  Returns `true` if the CSRF token matches the stored one, otherwise `false`.

  """
  @spec authorized?(integer(), String.t()) :: boolean()
  def authorized?(user_id, csrf) do
    get(user_id) == csrf
  end

  @doc """
  Returns the CSRF token from a `conn` by reading `x-csrf-token` header.

  ## Parameters

  - `conn` (type: Plug.Conn.t()): The Plug connection.

  ## Returns

  Returns a tuple `{:ok, csrf}` if the CSRF token is found, or `{:error, reason}` if not found.

  """
  @spec get_from_conn(Plug.Conn.t()) :: {:ok, String.t()} | {:error, String.t()}
  def get_from_conn(conn) do
    case Plug.Conn.get_req_header(conn, "x-csrf-token") do
      [csrf] -> {:ok, csrf}
      _ -> {:error, "csrf token not found"}
    end
  end
end
