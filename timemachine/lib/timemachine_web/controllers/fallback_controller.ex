defmodule TimemachineWeb.FallbackController do
  @moduledoc false
  use TimemachineWeb, :controller

  # This clause handles errors returned by Ecto's insert/update/delete.
  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(json: TimemachineWeb.ChangesetJSON)
    |> render(:error, changeset: changeset)
  end

  # This clause is an example of how to handle resources that cannot be found.
  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(html: TimemachineWeb.ErrorHTML, json: TimemachineWeb.ErrorJSON)
    |> render(:"404")
  end

  # Generic error handler (author: Nicolas)
  def call(conn, {:error, status}) do
    conn
    |> put_status(status)
    |> put_view(html: TimemachineWeb.ErrorHTML, json: TimemachineWeb.ErrorJSON)
    |> render(to_string(status) <> ".json")
  end
end
