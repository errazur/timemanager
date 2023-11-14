defmodule Timemachine.DataFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Timemachine.Data` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        "email" => "some@email.com",
        "username" => "some username",
        "password" => "mdp"
      })
      |> Timemachine.Data.user_create()

    user
  end

  @doc """
  Generate a clock.
  """
  def clock_fixture(attrs \\ %{}) do
    {:ok, clock} =
      attrs
      |> Enum.into(%{
        status: true,
        time: ~U[2023-10-23 09:21:00Z],
      })
      |> Timemachine.Data.clock_create()

    clock
  end

  @doc """
  Generate a workingtime.
  """
  def workingtime_fixture(attrs \\ %{}) do
    user = user_fixture()
    attrs = Map.merge(
      %{
        end: ~U[2023-10-23 19:26:00Z],
        start: ~U[2023-10-23 10:26:00Z]
      },
      attrs
    )
    {:ok, workingtime} = Timemachine.Data.workingtime_create(attrs, user.id)
    workingtime
  end

  @doc """
  Generate a team.
  """
  def team_fixture(attrs \\ %{}) do
    {:ok, team} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Timemachine.Data.team_create()

    team
  end
end
