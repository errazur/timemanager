defmodule TimemachineWeb.WorkingtimeController do
  use TimemachineWeb, :controller

  alias Timemachine.Data
  alias Timemachine.Data.Workingtime

  action_fallback TimemachineWeb.FallbackController

  @moduledoc """
  Controller for managing working times.

  ## Actions

  - `index(conn, params)`: Get a list of working times based on user_id, start_time, and end_time.
  - `create(conn, %{"user_id" => user_id, "workingtime" => workingtime_params})`: Create a working time entry.
  - `show(conn, %{"id" => id, "user_id" => user_id})`: Show details of a working time entry.
  - `update(conn, %{"id" => id, "workingtime" => workingtime_params})`: Update a working time entry.
  - `delete(conn, %{"id" => id})`: Delete a working time entry.
  - `get_by_team(conn, params)`: Get a list of working times for a team based on team_id, start_time, and end_time.
  - `create_for_team(conn, %{"team_id" => team_id, "workingtime" => workingtime_params})`: Create working time entries for a team.

  """

  @doc """
  Get a list of working times based on user_id, start_time, and end_time.

  ## Parameters

  - `conn` (type: Plug.Conn.t()): The connection struct.
  - `params` (type: map()): Map containing parameters, including `"user_id"`, `"start"`, and `"end"`.

  ## Returns

  Responds with a list of working times.

  """
  def index(conn, params) do
    user_id = Map.get(params, "user_id")
    user_id = String.to_integer(user_id)
    start_time = Map.get(params, "start")
    end_time = Map.get(params, "end")

    workingtimes = Data.workingtime_search(user_id, start_time, end_time)
    render(conn, :index, workingtimes: workingtimes)
  end

  @doc """
  Create a working time entry.

  ## Parameters

  - `conn` (type: Plug.Conn.t()): The connection struct.
  - `params` (type: map()): Map containing parameters, including `"user_id"` and `"workingtime"`.

  ## Returns

  Responds with the created working time entry.

  """
  def create(conn, %{"user_id" => user_id, "workingtime" => workingtime_params}) do
    user_id = String.to_integer(user_id)
    with {:ok, %Workingtime{} = workingtime} <- Data.workingtime_create(workingtime_params, user_id) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/workingtimes/#{workingtime.user_id}/#{workingtime.id}")
      |> render(:show, workingtime: workingtime)
    end
  end

  @doc """
  Show details of a working time entry.

  ## Parameters

  - `conn` (type: Plug.Conn.t()): The connection struct.
  - `params` (type: map()): Map containing parameters, including `"id"` and `"user_id"`.

  ## Returns

  Responds with the details of the specified working time entry.

  """
  def show(conn, %{"id" => id, "user_id" => user_id}) do
    user_id = String.to_integer(user_id)
    workingtime = Data.workingtime_get(id)
    if Map.get(workingtime, :user_id) == user_id do
      render(conn, :show, workingtime: workingtime)
    end
  end

  @doc """
  Update a working time entry.

  ## Parameters

  - `conn` (type: Plug.Conn.t()): The connection struct.
  - `params` (type: map()): Map containing parameters, including `"id"` and `"workingtime"`.

  ## Returns

  Responds with the updated working time entry.

  """
  def update(conn, %{"id" => id, "workingtime" => workingtime_params}) do
    workingtime = Data.workingtime_get(id)

    with {:ok, %Workingtime{} = workingtime} <- Data.workingtime_update(workingtime, workingtime_params) do
      render(conn, :show, workingtime: workingtime)
    end
  end

  @doc """
  Delete a working time entry.

  ## Parameters

  - `conn` (type: Plug.Conn.t()): The connection struct.
  - `params` (type: map()): Map containing parameters, including `"id"`.

  ## Returns

  Responds with a `:no_content` status.

  """
  def delete(conn, %{"id" => id}) do
    workingtime = Data.workingtime_get(id)

    with {:ok, %Workingtime{}} <- Data.workingtime_delete(workingtime) do
      send_resp(conn, :no_content, "")
    end
  end

  @doc """
  Get a list of working times for a team based on team_id, start_time, and end_time.

  ## Parameters

  - `conn` (type: Plug.Conn.t()): The connection struct.
  - `params` (type: map()): Map containing parameters, including `"team_id"`, `"start"`, and `"end"`.

  ## Returns

  Responds with a list of working times for the specified team.

  """
  def get_by_team(conn, params) do
    team_id = Map.get(params, "team_id")
    team_id = String.to_integer(team_id)
    start_time = Map.get(params, "start")
    end_time = Map.get(params, "end")

    team = Data.team_get(team_id)

    workingtimes = List.flatten(
      for(user <- team.users, do: Data.workingtime_search(user.id, start_time, end_time))
    )

    render(conn, :index, workingtimes: workingtimes)
  end

  @doc """
  Create working time entries for a team.

  ## Parameters

  - `conn` (type: Plug.Conn.t()): The connection struct.
  - `params` (type: map()): Map containing parameters, including `"team_id"` and `"workingtime"`.

  ## Returns

  Responds with a `:no_content` status.

  """
  def create_for_team(conn, %{"team_id" => team_id, "workingtime" => workingtime_params}) do
    team_id = String.to_integer(team_id)

    team = Data.team_get(team_id)

    for(user <- team.users, do: Data.workingtime_create(workingtime_params, user.id))

    send_resp(conn, :no_content, "")
  end
end
