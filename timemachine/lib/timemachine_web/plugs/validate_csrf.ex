defmodule TimemachineWeb.Plugs.ValidateCSRF do
  alias Timemachine.Tokens.Bearer
  alias Timemachine.Tokens.CSRF
  alias TimemachineWeb.FallbackController

  def init(default), do: default

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
