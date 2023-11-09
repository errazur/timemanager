defmodule TimemachineWeb.Plugs.ValidateBearer do
  import Plug.Conn

  alias Timemachine.Token
  alias TimemachineWeb.FallbackController
  alias Timemachine.Utils

  def init(default), do: default

  def call(conn, _default), do: authenticate(conn)

  defp authenticate(conn) do
    case Utils.get_bearer_token(conn) do
      {:error, _reason} ->
        FallbackController.call(conn, {:error, 401})

      {:ok, bearer} ->
        case Token.verify_and_validate(bearer) do
          {:error, _reason} ->
            FallbackController.call(conn, {:error, 401})

          {:ok, claims} ->
            conn
        end
    end
  end

end
