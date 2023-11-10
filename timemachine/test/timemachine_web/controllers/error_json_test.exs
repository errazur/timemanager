defmodule TimemachineWeb.ErrorJSONTest do
  use TimemachineWeb.ConnCase, async: true

  test "renders 404" do
    assert TimemachineWeb.ErrorJSON.render("404.json", %{}) ==
      %{"message" => "Not Found", "ok" => false, "status" => 404}
  end

  test "renders 500" do
    assert TimemachineWeb.ErrorJSON.render("500.json", %{}) ==
      %{"message" => "Internal Server Error", "ok" => false, "status" => 500}
  end
end
