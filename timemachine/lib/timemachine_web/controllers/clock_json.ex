defmodule TimemachineWeb.ClockJSON do
  @moduledoc false

  alias Timemachine.Data.Clock

  @doc """
  Renders a list of clocks.
  """
  def index(%{clocks: clocks}) do
    %{data: for(clock <- clocks, do: data(clock))}
  end

  @doc """
  Renders a given clock.
  """
  def show(%{clock: clock}) do
    %{data: data(clock)}
  end

  defp data(%Clock{} = clock) do
    %{
      id: clock.id,
      time: clock.time,
      status: clock.status,
      user_id: clock.user_id,
      user: TimemachineWeb.UserJSON.data_no_teams(clock.user)
    }
  end
end
