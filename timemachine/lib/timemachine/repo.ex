defmodule Timemachine.Repo do
  @moduledoc false

  use Ecto.Repo,
    otp_app: :timemachine,
    adapter: Ecto.Adapters.Postgres
end
