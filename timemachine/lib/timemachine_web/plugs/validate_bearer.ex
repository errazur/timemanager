defmodule TimemachineWeb.Plugs.ValidateBearer do
  alias Timemachine.Tokens.Bearer
  alias TimemachineWeb.FallbackController

  def init(default), do: default

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
