defmodule Timemachine.Repo do
  use Ecto.Repo,
    otp_app: :timemachine,
    adapter: Ecto.Adapters.Postgres
end
