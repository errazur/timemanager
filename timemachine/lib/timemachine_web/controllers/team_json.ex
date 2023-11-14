defmodule TimemachineWeb.TeamJSON do
  @moduledoc false

  alias Timemachine.Data.Team

  def index(%{teams: teams}) do
    %{data: for(team <- teams, do: data(team))}
  end

  def show(%{team: team}) do
    %{data: data(team)}
  end

  def data(%Team{} = team) do
    %{
      id: team.id,
      name: team.name,
      users: for(user <- team.users, do: TimemachineWeb.UserJSON.data_no_teams(user))
    }
  end

  # prevents infinite loop
  def data_no_users(%Team{} = team) do
    %{
      id: team.id,
      name: team.name,
    }
  end
end
