defmodule IdScrew.Repo do
  use Ecto.Repo,
    otp_app: :id_screw,
    adapter: Ecto.Adapters.Postgres
end
