defmodule TimemachineWeb.TeamController do
  use TimemachineWeb, :controller

  alias Timemachine.Data
  alias Timemachine.Data.Team

  action_fallback TimemachineWeb.FallbackController

  @moduledoc """
  Controller for managing team data.

  ## Actions

  - `index(conn, _params)`: Retrieve a list of all teams.
  - `create(conn, %{"team" => team_params})`: Create a new team.
  - `show(conn, %{"id" => id})`: Retrieve details of a specific team.
  - `update(conn, %{"id" => id, "team" => team_params})`: Update details of a specific team.
  - `delete(conn, %{"id" => id})`: Delete a specific team.

  """

  @doc """
  Retrieve a list of all teams.

  ## Parameters

  - `conn` (type: Plug.Conn.t()): The connection struct.
  - `params` (type: map()): Map containing parameters (not used).

  ## Returns

  Renders the `:index` view with a list of all teams.

  """
  def index(conn, _params) do
    teams = Data.team_list()
    render(conn, :index, teams: teams)
  end

  @doc """
  Create a new team.

  ## Parameters

  - `conn` (type: Plug.Conn.t()): The connection struct.
  - `params` (type: map()): Map containing parameters, including `"team"`.

  ## Returns

  Renders the `:show` view with the details of the created team.

  """
  def create(conn, %{"team" => team_params}) do
    with {:ok, %Team{} = team} <- Data.team_create(team_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/teams/#{team}")
      |> render(:show, team: team)
    end
  end

  @doc """
  Retrieve details of a specific team.

  ## Parameters

  - `conn` (type: Plug.Conn.t()): The connection struct.
  - `params` (type: map()): Map containing parameters, including `"id"`.

  ## Returns

  Renders the `:show` view with details of the specified team.

  """
  def show(conn, %{"id" => id}) do
    team = Data.team_get(id)
    render(conn, :show, team: team)
  end

  @doc """
  Update details of a specific team.

  ## Parameters

  - `conn` (type: Plug.Conn.t()): The connection struct.
  - `params` (type: map()): Map containing parameters, including `"id"` and `"team"`.

  ## Returns

  Renders the `:show` view with the updated details of the team.

  """
  def update(conn, %{"id" => id, "team" => team_params}) do
    team = Data.team_get(id)

    with {:ok, %Team{} = team} <- Data.team_update(team, team_params) do
      render(conn, :show, team: team)
    end
  end

  @doc """
  Delete a specific team.

  ## Parameters

  - `conn` (type: Plug.Conn.t()): The connection struct.
  - `params` (type: map()): Map containing parameters, including `"id"`.

  ## Returns

  Responds with a `:no_content` status.

  """
  def delete(conn, %{"id" => id}) do
    team = Data.team_get(id)

    with {:ok, %Team{}} <- Data.team_delete(team) do
      send_resp(conn, :no_content, "")
    end
  end
end
