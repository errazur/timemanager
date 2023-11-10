#defmodule TimemachineWeb.ClockControllerTest do
#  use TimemachineWeb.ConnCase
#
#  import Timemachine.AccountsFixtures
#
#  @create_attrs %{
#    status: true,
#    time: ~U[2023-10-23 09:21:00Z]
#  }
#  @invalid_attrs %{
#    status: nil,
#    time: nil,
#    user_id: nil
#  }
#  setup %{conn: conn} do
#    token = TimemachineWeb.UserJSON.jwt(%{user: user_fixture(), csrf: "token"})
#    conn_with_header = put_req_header(conn, "accept", "application/json")
#    conn_with_auth_header = put_req_header(conn_with_header, "authorization", "Bearer #{token.bearer}")
#    {:ok, conn: conn_with_auth_header}
#  end
#
#  describe "create clock" do
#    test "with valid data creates a clock", %{conn: conn} do
#      user = user_fixture()
#      user_id = user.id
#      conn = post(conn, ~p"/api/clocks/#{user_id}", clock: @create_attrs)
#      assert %{"id" => id} = json_response(conn, 201)["data"]
#
#      conn = get(conn, ~p"/api/clocks/#{user_id}")
#      json_data = json_response(conn, 200)["data"]
#      first_item = Enum.at(json_data, 0)
#      user_id_in_response = Map.get(first_item, "user_id")
#
#      assert user_id_in_response == user_id
#    end
#
#    test "with invalid data returns error changeset", %{conn: conn} do
#      user = user_fixture()
#      user_id = user.id
#      conn = post(conn, ~p"/api/clocks/#{user}", clock: @invalid_attrs, user: user_id)
#      assert json_response(conn, 422)["errors"] != %{}
#    end
#  end
#end
