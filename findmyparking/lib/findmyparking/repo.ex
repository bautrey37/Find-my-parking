defmodule Findmyparking.Repo do
  use Ecto.Repo,
    otp_app: :findmyparking,
    adapter: Ecto.Adapters.Postgres
end
