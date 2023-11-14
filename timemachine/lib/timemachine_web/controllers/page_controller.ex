defmodule TimemachineWeb.Page do
  @moduledoc false
  use TimemachineWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end

  def docs(conn, _params) do
    file = File.read!("doc/index.html")
    IO.inspect(file)
    html(conn, file)
  end
end
