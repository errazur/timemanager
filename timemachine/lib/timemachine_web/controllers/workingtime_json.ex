defmodule TimemachineWeb.WorkingtimeJSON do
  @moduledoc false

  alias Timemachine.Data.Workingtime

  @doc """
  Renders a list of workingtimes.
  """
  def index(%{workingtimes: workingtimes}) do
    %{data: for(workingtime <- workingtimes, do: data(workingtime))}
  end

  @doc """
  Renders a single workingtime.
  """
  def show(%{workingtime: workingtime}) do
    %{data: data(workingtime)}
  end

  defp data(%Workingtime{} = workingtime) do
    %{
      id: workingtime.id,
      start: workingtime.start,
      end: workingtime.end,
      user_id: workingtime.user_id,
      user: TimemachineWeb.UserJSON.data_no_teams(workingtime.user)
    }
  end
end
