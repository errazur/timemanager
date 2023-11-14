defmodule TimemachineWeb.UserTeamController do
  use TimemachineWeb, :controller

  alias Timemachine.Data
  alias Timemachine.Data.UserTeam

  action_fallback TimemachineWeb.FallbackController

  @moduledoc """
  Controller for managing user-team associations.

  ## Actions

  - `add(conn, %{"user_id" => user_id, "team_id" => team_id})`: Add a user to a team.
  - `remove(conn, %{"user_id" => user_id, "team_id" => team_id})`: Remove a user from a team.

  """

  @doc """
  Add a user to a team.

  ## Parameters

  - `conn` (type: Plug.Conn.t()): The connection struct.
  - `params` (type: map()): Map containing parameters, including `"user_id"` and `"team_id"`.

  ## Returns

  Responds with a `:no_content` status.

  """
  def add(conn, %{"user_id" => user_id, "team_id" => team_id}) do
    with {:ok, %UserTeam{}} <- Data.userteam_create(user_id, team_id) do
      send_resp(conn, :no_content, "")
    end
  end

  @doc """
  Remove a user from a team.

  ## Parameters

  - `conn` (type: Plug.Conn.t()): The connection struct.
  - `params` (type: map()): Map containing parameters, including `"user_id"` and `"team_id"`.

  ## Returns

  Responds with a `:no_content` status.

  """
  def remove(conn, %{"user_id" => user_id, "team_id" => team_id}) do
    with {:ok, %UserTeam{}} <- Data.userteam_delete(user_id, team_id) do
      send_resp(conn, :no_content, "")
    end
  end
end
