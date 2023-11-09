defmodule TimemachineWeb.WorkingtimeControllerTest do
  use TimemachineWeb.ConnCase

  import Timemachine.AccountsFixtures

  alias Timemachine.Accounts.Workingtime

  @create_attrs %{
    start: ~U[2023-10-23 14:26:00Z],
    end: ~U[2023-10-23 14:26:00Z]
  }
  @update_attrs %{
    start: ~U[2023-10-24 14:26:00Z],
    end: ~U[2023-10-24 14:26:00Z]
  }
  @invalid_attrs %{start: nil, end: nil}

  setup %{conn: conn} do
    token = TimemachineWeb.UserJSON.jwt(%{user: user_fixture(), csrf: "token"})
    conn_with_header = put_req_header(conn, "accept", "application/json")
    conn_with_auth_header = put_req_header(conn_with_header, "authorization", "Bearer #{token.bearer}")
    {:ok, conn: conn_with_auth_header}
  end

  describe "create workingtime" do
    test "renders workingtime when data is valid", %{conn: conn} do
      user = user_fixture()
      user_id = user.id
      conn = post(conn, ~p"/api/workingtimes/#{user_id}", workingtime: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/workingtimes/#{user_id}/#{id}")
      json_data = json_response(conn, 200)["data"]
      user_id_in_response = Map.get(json_data, "user_id")

      assert user_id_in_response == user.id
    end

    test "renders errors when data is invalid", %{conn: conn} do
      user = user_fixture()
      user_id = user.id
      conn = post(conn, ~p"/api/workingtimes/#{user_id}", workingtime: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update workingtime" do
    test "renders workingtime when data is valid", %{conn: conn} do
      workingtime = workingtime_fixture()
      conn = put(conn, ~p"/api/workingtimes/#{workingtime}", workingtime: @update_attrs)
      assert %{"id" => id} = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      workingtime = workingtime_fixture()
      conn = put(conn, ~p"/api/workingtimes/#{workingtime}", workingtime: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete workingtime" do
    test "deletes chosen workingtime", %{conn: conn} do
      workingtime = workingtime_fixture()
      conn = delete(conn, ~p"/api/workingtimes/#{workingtime}")
      assert response(conn, 204)
    end
  end
end
