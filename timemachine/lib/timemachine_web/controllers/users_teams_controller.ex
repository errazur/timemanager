defmodule TimemachineWeb.UserTeamController do
  use TimemachineWeb, :controller

  alias Timemachine.Data
  alias Timemachine.Data.UserTeam

  action_fallback TimemachineWeb.FallbackController

  def add(conn, %{"user_id" => user_id, "team_id" => team_id}) do
    with {:ok, %UserTeam{}} <- Data.userteam_create(user_id, team_id) do
      send_resp(conn, :no_content, "")
    end
  end

  def remove(conn, %{"user_id" => user_id, "team_id" => team_id}) do
    with {:ok, %UserTeam{}} <- Data.userteam_delete(user_id, team_id) do
      send_resp(conn, :no_content, "")
    end
  end
end
