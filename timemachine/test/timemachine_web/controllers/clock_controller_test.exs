defmodule TimemachineWeb.ClockControllerTest do
  use TimemachineWeb.ConnCase

  import Timemachine.AccountsFixtures

  alias Timemachine.Tokens.CSRF

  @create_attrs %{
    status: true,
    time: ~U[2023-10-23 09:21:00Z]
  }

  @invalid_attrs %{
    status: nil,
    time: nil,
    user_id: nil
  }

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

  describe "create clock" do
    test "with valid data creates a clock", %{conn: conn, user: user} do
      conn = post(conn, ~p"/api/clocks/#{user.id}", clock: @create_attrs)
      assert %{"id" => _id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/clocks/#{user.id}")
      json_data = json_response(conn, 200)["data"]
      first_item = Enum.at(json_data, 0)
      user_id_in_response = Map.get(first_item, "user_id")

      assert user_id_in_response == user.id
    end

    test "with invalid data returns error changeset", %{conn: conn, user: user} do
      conn = post(conn, ~p"/api/clocks/#{user.id}", clock: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end
end
