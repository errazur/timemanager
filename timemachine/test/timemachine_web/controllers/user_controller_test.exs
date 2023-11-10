defmodule TimemachineWeb.UserControllerTest do
  use TimemachineWeb.ConnCase

  import Timemachine.AccountsFixtures

  alias Timemachine.Tokens.CSRF

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
    test "lists all users", %{conn: conn} do
      conn = get(conn, ~p"/api/users")
      user = hd(conn.assigns[:users])
      assert json_response(conn, 200)["data"] == [
        %{"email" => user.email, "id" => user.id, "username" => user.username, "teams" => []}
      ]
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

    test "renders user when data is valid", %{conn: conn, user: user} do
      user_id = user.id
      csrf = CSRF.get(user_id)
      conn = put(conn, ~p"/api/users/#{user_id}", user: @update_attrs)
      assert ^csrf = json_response(conn, 200)["_csrf_token"]

      conn = get(conn, ~p"/api/users/#{user_id}")

      assert %{
        "id" => ^user_id,
        "email" => "some@updated.email",
        "username" => "some updated username"
      } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
       user_id = user.id
      conn = put(conn, ~p"/api/users/#{user_id}", user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do

    test "deletes chosen user", %{conn: conn, user: user} do
       user_id = user.id
      conn = delete(conn, ~p"/api/users/#{user_id}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/users/#{user_id}")
      end
    end
  end
end
