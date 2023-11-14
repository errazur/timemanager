defmodule TimemachineWeb.ErrorJSON do
  @moduledoc false

  # If you want to customize a particular status code,
  # you may add your own clauses, such as:
  #
  # def render("500.json", _assigns) do
  #   %{errors: %{detail: "Internal Server Error"}}
  # end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.json" becomes
  # "Not Found".
  def render(template, _assigns) do
    %{
      "status" => template |> String.split(".") |> hd() |> String.to_integer(),
      "ok" => false,
      "message" => Phoenix.Controller.status_message_from_template(template),
    }
  end
end
