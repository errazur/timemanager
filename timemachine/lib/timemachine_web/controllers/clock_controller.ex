defmodule TimemachineWeb.ClockController do
  use TimemachineWeb, :controller

  alias Timemachine.Accounts
  alias Timemachine.Accounts.Clock
  alias Timemachine.Utils

  action_fallback TimemachineWeb.FallbackController

  def create(conn, %{"clock" => clock_params, "user_id" => user_id}) do
    user_id = String.to_integer(user_id)

    boolean_status = Utils.parse_boolean(clock_params["status"])
    clock_params = if boolean_status != nil,
      do: Map.replace(clock_params, "status", boolean_status),
      else: clock_params

    with {:ok, %Clock{} = clock} <- Accounts.create_clock(clock_params, user_id) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/clocks/#{clock}")
      |> render(:show, clock: clock)
    end
  end

  def index(conn, %{"user_id" => user_id}) do
    user_id = String.to_integer(user_id)
    clocks = Accounts.get_clocks!(user_id)
    render(conn, :index, clocks: clocks)
  end

end
