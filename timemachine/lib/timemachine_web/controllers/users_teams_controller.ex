defmodule TimemachineWeb.UserTeamController do
  use TimemachineWeb, :controller

  alias Timemachine.Accounts
  alias Timemachine.Accounts.UserTeam

  action_fallback TimemachineWeb.FallbackController

  def add(conn, %{"user_id" => user_id, "team_id" => team_id}) do
    with {:ok, %UserTeam{}} <- Accounts.create_user_team(user_id, team_id) do
      send_resp(conn, :no_content, "")
    end
  end

  def remove(conn, %{"user_id" => user_id, "team_id" => team_id}) do
    with {:ok, %UserTeam{}} <- Accounts.delete_user_team(user_id, team_id) do
      send_resp(conn, :no_content, "")
    end
  end
end
