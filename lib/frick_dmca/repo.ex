defmodule FrickDmca.Repo do
  use Ecto.Repo,
    otp_app: :frick_dmca,
    adapter: Ecto.Adapters.Postgres
end
