defmodule TimemachineWeb.WorkingtimeController do
  use TimemachineWeb, :controller

  alias Timemachine.Accounts
  alias Timemachine.Accounts.Workingtime

  action_fallback TimemachineWeb.FallbackController

  def index(conn, params) do
    user_id = Map.get(params, "user_id")
    user_id = String.to_integer(user_id)
    start_time = Map.get(params, "start")
    end_time = Map.get(params, "end")

    workingtimes = Accounts.search_workingtimes(user_id, start_time, end_time)
    render(conn, :index, workingtimes: workingtimes)
  end

  def create(conn, %{ "user_id" => user_id, "workingtime" => workingtime_params}) do
    user_id = String.to_integer(user_id)
    with {:ok, %Workingtime{} = workingtime} <- Accounts.create_workingtime(workingtime_params, user_id) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/workingtimes/#{workingtime.user_id}/#{workingtime.id}")
      |> render(:show, workingtime: workingtime)
    end
  end

  def show(conn, %{"id" => id, "user_id" => user_id}) do
    user_id = String.to_integer(user_id)
    workingtime = Accounts.get_workingtime!(id)
    if Map.get(workingtime, :user_id) == user_id do
      render(conn, :show, workingtime: workingtime)
    end
  end

  def update(conn, %{"id" => id, "workingtime" => workingtime_params}) do
    workingtime = Accounts.get_workingtime!(id)

    with {:ok, %Workingtime{} = workingtime} <- Accounts.update_workingtime(workingtime, workingtime_params) do
      render(conn, :show, workingtime: workingtime)
    end
  end

  def delete(conn, %{"id" => id}) do
    workingtime = Accounts.get_workingtime!(id)

    with {:ok, %Workingtime{}} <- Accounts.delete_workingtime(workingtime) do
      send_resp(conn, :no_content, "")
    end
  end

end
