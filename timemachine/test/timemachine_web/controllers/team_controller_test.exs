defmodule TimemachineWeb.TeamControllerTest do
  use TimemachineWeb.ConnCase

  import Timemachine.DataFixtures

  alias Timemachine.Tokens.CSRF

  @create_attrs %{name: "some name"}

  @update_attrs %{name: "some updated name"}

  @invalid_attrs %{name: nil}

  setup %{conn: conn} do
    user = user_fixture()

    CSRF.generate(user.id)

    token = TimemachineWeb.UserJSON.jwt(%{user: user, csrf: CSRF.get(user.id)})

    {:ok, user: user, conn:
      conn
      |> put_req_header("accept", "application/json")
      |> put_req_header("authorization", "Bearer #{token.bearer}")
      |> put_req_header("x-csrf-token", CSRF.get(user.id))
    }
  end

  describe "index" do
    test "lists all teams", %{conn: conn} do
      conn = get(conn, ~p"/api/teams")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create team" do
    test "renders team when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/teams", team: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]
      conn = get(conn, ~p"/api/teams/#{id}")
      assert %{
        "id" => ^id,
        "name" => "some name"
      } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/teams", team: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update team" do
    setup [:team_create]

    test "renders team when data is valid", %{conn: conn, team: team} do
      team_id = team.id
      conn = put(conn, ~p"/api/teams/#{team_id}", team: @update_attrs)
      assert %{"id" => ^team_id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/teams/#{team_id}")

      assert %{
        "id" => ^team_id,
        "name" => "some updated name"
      } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, team: team} do
      conn = put(conn, ~p"/api/teams/#{team}", team: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete team" do
    setup [:team_create]

    test "deletes chosen team", %{conn: conn, team: team} do
      team_id = team.id
      conn = delete(conn, ~p"/api/teams/#{team_id}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/teams/#{team_id}")
      end
    end
  end

  defp team_create(_) do
    team = team_fixture()
    %{team: team}
  end
end
