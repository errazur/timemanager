defmodule TimemachineWeb.TeamController do
  use TimemachineWeb, :controller

  alias Timemachine.Data
  alias Timemachine.Data.Team

  action_fallback TimemachineWeb.FallbackController

  def index(conn, _params) do
    teams = Data.team_list()
    render(conn, :index, teams: teams)
  end

  def create(conn, %{"team" => team_params}) do
    with {:ok, %Team{} = team} <- Data.team_create(team_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/teams/#{team}")
      |> render(:show, team: team)
    end
  end

  def show(conn, %{"id" => id}) do
    team = Data.team_get(id)
    render(conn, :show, team: team)
  end

  def update(conn, %{"id" => id, "team" => team_params}) do
    team = Data.team_get(id)

    with {:ok, %Team{} = team} <- Data.team_update(team, team_params) do
      render(conn, :show, team: team)
    end
  end

  def delete(conn, %{"id" => id}) do
    team = Data.team_get(id)

    with {:ok, %Team{}} <- Data.team_delete(team) do
      send_resp(conn, :no_content, "")
    end
  end
end
