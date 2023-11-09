defmodule TimemachineWeb.UserControllerTest do
  use TimemachineWeb.ConnCase

  import Timemachine.AccountsFixtures

  alias Timemachine.Accounts.User

  @create_attrs %{
    "username" => "some username",
    "email" => "some@email.com",
    "password" => "mdp"
  }
  @update_attrs %{
    "username" => "some updated username",
    "email" => "some@updated.email",
    "password" => "mdp"
  }
  @invalid_attrs %{"username" => nil, "email" => nil, "password" => nil}

  setup %{conn: conn} do
    token = TimemachineWeb.UserJSON.jwt(%{user: user_fixture(), csrf: "token"})
    conn_with_header = put_req_header(conn, "accept", "application/json")
    conn_with_auth_header = put_req_header(conn_with_header, "authorization", "Bearer #{token.bearer}")
    {:ok, conn: conn_with_auth_header}
  end


  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get(conn, ~p"/api/users")
      user = hd(conn.assigns[:users])
      assert json_response(conn, 200)["data"] == [%{"email" => user.email, "id" => user.id, "username" => user.username}]
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/users", user: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/users/#{id}")

      assert %{
               "id" => ^id,
               "email" => "some@email.com",
               "username" => "some username"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/users", user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      conn = put(conn, ~p"/api/users/#{user}", user: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/users/#{id}")

      assert %{
               "id" => ^id,
               "email" => "some@updated.email",
               "username" => "some updated username"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, ~p"/api/users/#{user}", user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, ~p"/api/users/#{user}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/users/#{user}")
      end
    end
  end

  defp create_user(_) do
    user = user_fixture()
    %{user: user}
  end
end
