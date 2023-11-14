defmodule TimemachineWeb.WorkingtimeController do
  use TimemachineWeb, :controller

  alias Timemachine.Data
  alias Timemachine.Data.Workingtime

  action_fallback TimemachineWeb.FallbackController

  def index(conn, params) do
    user_id = Map.get(params, "user_id")
    user_id = String.to_integer(user_id)
    start_time = Map.get(params, "start")
    end_time = Map.get(params, "end")

    workingtimes = Data.workingtime_search(user_id, start_time, end_time)
    render(conn, :index, workingtimes: workingtimes)
  end

  def create(conn, %{ "user_id" => user_id, "workingtime" => workingtime_params}) do
    user_id = String.to_integer(user_id)
    with {:ok, %Workingtime{} = workingtime} <- Data.workingtime_create(workingtime_params, user_id) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/workingtimes/#{workingtime.user_id}/#{workingtime.id}")
      |> render(:show, workingtime: workingtime)
    end
  end

  def show(conn, %{"id" => id, "user_id" => user_id}) do
    user_id = String.to_integer(user_id)
    workingtime = Data.workingtime_get(id)
    if Map.get(workingtime, :user_id) == user_id do
      render(conn, :show, workingtime: workingtime)
    end
  end

  def update(conn, %{"id" => id, "workingtime" => workingtime_params}) do
    workingtime = Data.workingtime_get(id)

    with {:ok, %Workingtime{} = workingtime} <- Data.workingtime_update(workingtime, workingtime_params) do
      render(conn, :show, workingtime: workingtime)
    end
  end

  def delete(conn, %{"id" => id}) do
    workingtime = Data.workingtime_get(id)

    with {:ok, %Workingtime{}} <- Data.workingtime_delete(workingtime) do
      send_resp(conn, :no_content, "")
    end
  end

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

  def create_for_team(conn, %{"team_id" => team_id, "workingtime" => workingtime_params}) do
    team_id = String.to_integer(team_id)

    team = Data.team_get(team_id)

    for(user <- team.users, do: Data.workingtime_create(workingtime_params, user.id))

    send_resp(conn, :no_content, "")
  end

end
